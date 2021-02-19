require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  context 'Association tests' do
    it { should have_many(:items).dependent(:destroy) }
  end

  context 'name validations' do
    before :each do
      @name = 'dismas'
      @email = 'email@gmai.com'
      @password = 'password'
    end

    it 'should not save if name is not provided' do
      user = User.new(email: @email, password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should not save if name is less than 5 characters' do
      user = User.new(name: 'd', email: @email, password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should not save if name is more than 50 characters' do
      name = 'long namelong namelong namelong namelong namelong namelong namelong name'
      user = User.new(name: name, email: @email, password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should save user if name is at least 5 and at most 50 characters long' do
      user = User.new(name: @name, email: @email, password_digest: @password).save

      expect(user).to eq(true)
    end
  end

  context 'Password validations' do
    before :each do
      @name = 'dismas'
      @email = 'email@gmai.com'
      @password = 'password'
    end

    it 'should not save if password is not provided' do
      user = User.new(email: @email, name: @name).save

      expect(user).to eq(false)
    end

    it 'should not save if password is less than 5 characters' do
      user = User.new(name: @name, email: @email, password_digest: 'pass').save

      expect(user).to eq(false)
    end

    it 'should not save if password is more than 1024 characters' do
      long_password = 'long passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password
              long passwordlong passwordlong passwordlong passwordlong passwordlong passwordlong password'
      user = User.new(name: @name, email: @email, password_digest: long_password).save

      expect(user).to eq(false)
    end

    it 'should save user if password is at least 5 and at most 1024 characters long' do
      user = User.new(name: @name, email: @email, password_digest: @password).save

      expect(user).to eq(true)
    end
  end

  context 'Email validations' do
    before :each do
      @name = 'dismas'
      @email = 'email@gmai.com'
      @password = 'password'
    end

    it 'should not save if email is not provided' do
      user = User.new(name: @name, password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should not save if email is less than 5 characters' do
      user = User.new(name: @name, email: 'a', password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should not save if email is more than 50 characters' do
      email = 'longemaillongemaillongemaillongemaillongemaillongemaillongemaillongemaillongemaillongemail@gmail.com'
      user = User.new(name: @name, email: email, password_digest: @password).save

      expect(user).to eq(false)
    end

    it 'should not save if email is not of correct format' do
      bad_email1 = 'abcde.com'
      user1 = User.new(name: @name, email: bad_email1, password_digest: @password).save
      expect(user1).to eq(false)

      bad_email2 = 'abcde@gmail'
      user2 = User.new(name: @name, email: bad_email2, password_digest: @password).save
      expect(user2).to eq(false)

      bad_email3 = '@gmail.com'
      user3 = User.new(name: @name, email: bad_email3, password_digest: @password).save
      expect(user3).to eq(false)
    end

    it 'should not save if email is already registered' do
      User.new(name: @name, email: @email, password_digest: @password).save
      user2 = User.new(name: @name, email: @email, password_digest: @password).save

      expect(user2).to eq(false)
    end

    it 'should not save if same email with different cases is used ie. email is not case sensitive' do
      User.new(name: @name, email: @email, password_digest: @password).save
      user2 = User.new(name: @name, email: @email.upcase, password_digest: @password).save

      expect(user2).to eq(false)
    end

    it 'should save user if email, is at least 5 and at most 50 characters long and valid format' do
      user = User.new(name: @name, email: @email, password_digest: @password).save

      expect(user).to eq(true)
    end
  end
end
# rubocop:enable Metrics/BlockLength
