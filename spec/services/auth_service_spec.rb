require 'rails_helper'

RSpec.describe AuthService, type: :service do
  let(:service) { AuthService.new }
  let(:valid_attributes) { { name: "Test Student", email: "test@example.com", password: "Password@123", role: "user" } }
  
  describe '#signup' do
    context 'with valid parameters' do
      it 'creates a new student' do
        expect {
          result = service.signup(valid_attributes)
          expect(result[:success]).to be true
        }.to change(Student, :count).by(1)
      end
      
      it 'returns the student object' do
        result = service.signup(valid_attributes)
        expect(result[:student]).to be_a(Student)
        expect(result[:student].email).to eq("test@example.com")
      end
      
      it 'returns a token' do
        result = service.signup(valid_attributes)
        expect(result[:token]).not_to be_nil
      end
    end
    
    # context 'with invalid parameters' do
    #   it 'does not create a new student' do
    #     invalid_attributes = valid_attributes.merge(email: nil)
        
    #     expect {
    #       result = service.signup(invalid_attributes)
    #       expect(result[:success]).to be false
    #     }.not_to change(Student, :count)
    #   end
      
    #   it 'returns error messages' do
    #     invalid_attributes = valid_attributes.merge(email: nil)
        
    #     result = service.signup(invalid_attributes)
    #     expect(result[:errors]).not_to be_empty
    #     expect(service.errors).not_to be_empty
    #   end
    # end
  end
  
  describe '#login' do
    before do
      @student = Student.create!(valid_attributes)
    end
    
    context 'with valid credentials' do
      it 'returns success' do
        result = service.login("test@example.com", "Password@123")
        expect(result[:success]).to be true
      end
      
      it 'returns the student object' do
        result = service.login("test@example.com", "Password@123")
        expect(result[:student]).to eq(@student)
      end
      
      it 'returns a token' do
        result = service.login("test@example.com", "Password@123")
        expect(result[:token]).not_to be_nil
      end
    end
    
    context 'with invalid credentials' do
      it 'returns failure with wrong password' do
        result = service.login("test@example.com", "wrongpassword")
        expect(result[:success]).to be false
      end
      
      it 'returns failure with non-existent email' do
        result = service.login("nonexistent@example.com", "password123")
        expect(result[:success]).to be false
      end
      
      it 'adds error message to errors array' do
        service.login("test@example.com", "wrongpassword")
        expect(service.errors).to include("Invalid email or password")
      end
    end
  end
  
  describe '#logout' do
    it 'returns success' do
      result = service.logout
      expect(result[:success]).to be true
    end
  end
  
  describe '#is_logged_in?' do
    before do
      @student = Student.create!(valid_attributes)
    end
    
    it 'returns true for valid student id' do
      expect(service.is_logged_in?(@student.id)).to be true
    end
    
    it 'returns false for invalid student id' do
      expect(service.is_logged_in?(999)).to be false
    end
    
    it 'returns false for nil student id' do
      expect(service.is_logged_in?(nil)).to be false
    end
  end
  
  describe '#create_auth_token' do
    before do
      @student = Student.create!(valid_attributes)
    end
    
    it 'returns a hash with auth token options' do
      # token_options = service.send(:create_auth_token, @student)
      token_options = service.create_auth_token(@student)
      
      expect(token_options[:value]).to eq(@student.id)
      
    end
  end
  
end