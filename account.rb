#require 'riq'
require_relative 'lib/riq'
#require_relative 'lib/riq/client'
#require_relative 'lib/riq/contact'

RIQ.init('578e582be4b0db1095e6492b', 'UgYkKiZFaFLR5h9wuhq8iUxsSzn')
=begin
accounts = RIQ.accounts
#print accounts.to_a
accounts.each do |account|
  print account.to_yaml
end



contact = RIQ.contact('57927d4de4b0d25dce55f3ee')
p contact#.to_yaml


p contacts

contacts = RIQ.contacts

contacts.each do |contact|
  print contact.to_yaml
end



contacts = RIQ.lists

contacts.each do |contact|
  print contact.to_yaml
end
=end
=begin
lid = '578f81ade4b006015a5475c7'
@l = RIQ.list(lid)
@l.list_items.each do |li|
print li.to_yaml
  end


=end
#CREATE ACCOUNT
@a = RIQ.account
@a.name = 'Ruby Test Inc'

@a.field_value('address_city', 'Address Ruby address_city')
@a.field_value('address_state', 'Address Ruby address_state')
@a.field_value('address_postal_code', 'Address Ruby address_postal_code')
@a.field_value('address_country', 'Address Ruby address_country')
@a.field_value('address', 'Address Ruby address')
@a.field_value('primary_contact', 'Address Ruby primary_contact')

print @a.to_yaml
@a.save
print @a.to_yaml