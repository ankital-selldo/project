require 'rails_helper'

RSpec.describe EventService, type: :service do
  let(:student) { instance_double("Student", id: 1, role: "student", clubs: []) }
  let(:club_head) { instance_double("Student", id: 2, role: "club_head", clubs: [club]) }
  let(:club) { instance_double("Club", id: 1) }
  let(:event) { instance_double("Event", id: 1, club: club, club_id: 1, 
                               errors: double(full_messages: ["Error"]), 
                               registers: registers_association) }
  let(:registers_association) { instance_double("ActiveRecord::Associations::CollectionProxy") }
  let(:event_params) { { event_name: "Test Event", event_venue: "Test Venue" } }
  let(:policy_scope) { class_double("Event") }
  
  describe '#list_events' do
    it 'returns events with proper includes and order' do
      ordered_scope = instance_double("ActiveRecord::Relation")
      included_scope = instance_double("ActiveRecord::Relation")
      
      expect(policy_scope).to receive(:includes).with(:club).and_return(included_scope)
      expect(included_scope).to receive(:order).with(event_date: :asc, event_time: :asc).and_return(ordered_scope)
      
      service = EventService.new(student)
      expect(service.list_events(policy_scope)).to eq(ordered_scope)
    end
  end
  
  describe '#find_event' do
    it 'returns event when found' do
      allow(Event).to receive(:includes).with(:club).and_return(Event)
      allow(Event).to receive(:find).with(1).and_return(event)
      
      service = EventService.new(student)
      expect(service.find_event(1)).to eq(event)
    end
    
    it 'returns nil and adds error when event not found' do
      allow(Event).to receive(:includes).with(:club).and_return(Event)
      allow(Event).to receive(:find).with(999).and_raise(ActiveRecord::RecordNotFound)
      
      service = EventService.new(student)
      result = service.find_event(999)
      
      expect(result).to be_nil
      expect(service.errors).to include('Event not found')
    end
  end
  
  describe '#new_event' do
    it 'creates a new event instance' do
      allow(Event).to receive(:new).and_return(event)
      
      service = EventService.new(student)
      expect(service.new_event).to eq(event)
    end
    
    it 'assigns club_id if provided' do
      new_event = Event.new
      allow(Event).to receive(:new).and_return(new_event)
      
      service = EventService.new(student)
      result = service.new_event(club_id: 1)
      
      expect(result.club_id).to eq(1)
    end
  end
  
  describe '#create_event' do
    let(:new_event) { instance_double("Event", club_id: nil, save: true) }
    
    before do
      allow(Event).to receive(:new).and_return(new_event)
    end
    
    context 'when student is a club_head with no club_id provided' do
      it 'assigns the first club from student clubs' do
        club_head_clubs = [club]
        club_head = instance_double("Student", id: 2, role: "club_head", clubs: club_head_clubs)
        
        allow(new_event).to receive(:club_id).and_return(nil, 1)
        allow(new_event).to receive(:club_id=).with(1)
        
        service = EventService.new(club_head)
        result = service.create_event(event_params)
        
        expect(result[:success]).to be true
        expect(result[:event]).to eq(new_event)
      end
    end
    
    context 'when event saves successfully' do
      it 'returns success' do
        allow(new_event).to receive(:save).and_return(true)
        
        service = EventService.new(student)
        result = service.create_event(event_params)
        
        expect(result[:success]).to be true
        expect(result[:event]).to eq(new_event)
      end
    end
    
    context 'when event fails to save' do
      it 'returns errors' do
        allow(new_event).to receive(:save).and_return(false)
        allow(new_event).to receive(:errors).and_return(double(full_messages: ['Error']))
        
        service = EventService.new(student)
        result = service.create_event(event_params)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end
  
  describe '#update_event' do
    context 'when update is successful' do
      it 'returns success and the updated event' do
        allow(event).to receive(:update).with(event_params).and_return(true)
        
        service = EventService.new(student)
        result = service.update_event(event, event_params)
        
        expect(result[:success]).to be true
        expect(result[:event]).to eq(event)
      end
    end
    
    context 'when update fails' do
      it 'returns failure and errors' do
        allow(event).to receive(:update).with(event_params).and_return(false)
        
        service = EventService.new(student)
        result = service.update_event(event, event_params)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end
  
  describe '#destroy_event' do
    context 'when destroy is successful' do
      it 'returns success' do
        allow(event).to receive(:destroy).and_return(true)
        
        service = EventService.new(student)
        result = service.destroy_event(event)
        
        expect(result[:success]).to be true
      end
    end
    
    context 'when destroy fails' do
      it 'returns failure and errors' do
        allow(event).to receive(:destroy).and_return(false)
        
        service = EventService.new(student)
        result = service.destroy_event(event)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end
  
  describe '#event_registrations' do
    context 'when event exists' do
      it 'returns registrations' do
        registrations = [double('Registration')]
        allow(registers_association).to receive(:includes).with(:student).and_return(registrations)
        
        service = EventService.new(student)
        result = service.event_registrations(event)
        
        expect(result[:success]).to be true
        expect(result[:registrations]).to eq(registrations)
      end
    end
    
    context 'when event is nil' do
      it 'returns failure and error message' do
        service = EventService.new(student)
        result = service.event_registrations(nil)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to include('Event not found')
      end
    end
  end
  
  describe '#get_club_for_event' do
    it 'returns the club associated with the event' do
      service = EventService.new(student)
      result = service.get_club_for_event(event)
      
      expect(result).to eq(club)
    end
  end
  
  describe '#get_student_first_club' do
    it 'returns the first club of the current student' do
      service = EventService.new(club_head)
      result = service.get_student_first_club
      
      expect(result).to eq(club)
    end
  end

end