require 'rails_helper'

RSpec.describe ClubService, type: :service do
  let(:student) { instance_double("Student", id: 1) }
  let(:club) { instance_double("Club", id: 1, errors: double(full_messages: ["Error"])) }
  let(:club_params) { { club_name: "Test Club", club_logo: "logo.png" } }
  
  describe '#list_all_clubs' do
    it 'returns all clubs' do
      clubs = [club]
      allow(Club).to receive(:all).and_return(clubs)
      
      service = ClubService.new(student)
      expect(service.list_all_clubs).to eq(clubs)
    end
  end
  
  describe '#find_club' do
    it 'returns club when found' do
      allow(Club).to receive(:find).with(1).and_return(club)
      
      service = ClubService.new(student)
      expect(service.find_club(1)).to eq(club)
    end
    
    it 'returns nil and adds error when club not found' do
      allow(Club).to receive(:find).with(999).and_raise(ActiveRecord::RecordNotFound)
      
      service = ClubService.new(student)
      result = service.find_club(999)
      
      expect(result).to be_nil
      expect(service.errors).to include('Club not found')
    end
  end
  
  describe '#new_club' do
    it 'creates a new club instance' do
      new_club = Club.new
      allow(Club).to receive(:new).and_return(new_club)
      
      service = ClubService.new(student)
      expect(service.new_club).to eq(new_club)
    end
  end
  
  describe '#create_club' do
    let(:new_club) { instance_double("Club") }
    
    before do
      allow(Club).to receive(:new).and_return(new_club)
      allow(new_club).to receive(:student_id=).with(1)
    end
    
    context 'when club saves successfully' do
      it 'returns success' do
        allow(new_club).to receive(:save).and_return(true)
        
        service = ClubService.new(student)
        result = service.create_club(club_params)
        
        expect(result[:success]).to be true
        expect(result[:club]).to eq(new_club)
      end
    end
    
    context 'when club fails to save' do
      it 'returns errors' do
        allow(new_club).to receive(:save).and_return(false)
        allow(new_club).to receive(:errors).and_return(double(full_messages: ['Error']))
        
        service = ClubService.new(student)
        result = service.create_club(club_params)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end
  
  describe '#update_club' do
    context 'when update is successful' do
      it 'returns success and the updated club' do
        allow(club).to receive(:update).with(club_params).and_return(true)
        
        service = ClubService.new(student)
        result = service.update_club(club, club_params)
        
        expect(result[:success]).to be true
        expect(result[:club]).to eq(club)
      end
    end
    
    context 'when update fails' do
      it 'returns failure and errors' do
        allow(club).to receive(:update).with(club_params).and_return(false)
        
        service = ClubService.new(student)
        result = service.update_club(club, club_params)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end
  
  describe '#destroy_club' do
    context 'when destroy is successful' do
      it 'returns success' do
        allow(club).to receive(:destroy).and_return(true)
        
        service = ClubService.new(student)
        result = service.destroy_club(club)
        
        expect(result[:success]).to be true
      end
    end
    
    context 'when destroy fails' do
      it 'returns failure and errors' do
        allow(club).to receive(:destroy).and_return(false)
        
        service = ClubService.new(student)
        result = service.destroy_club(club)
        
        expect(result[:success]).to be false
        expect(result[:errors]).to eq(['Error'])
      end
    end
  end

end