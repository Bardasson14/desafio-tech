# frozen_string_literal: true

p 'Criando usuário admin'

user =  User.new(email: 'admin@teste.com', name: 'Admin', password: 'admin123')
user.jti = SecureRandom.uuid
user.save!