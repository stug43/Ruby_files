class Index
	attr_reader :data
	require_relative '../app/scrapper'
	require_relative 'done'
	require 'json'
	require 'google_drive'
	require 'csv'

	def lets_choose
		puts("Choisissez l'action que vous voulez effectuer\n\t< 1 > enregistrer les données au format JSON\n\t< 2 > enregistrer les données au format dans un spreadsheet Google\n\t< 3 > enregistrer les données au format CSV\n\t< 4 > quitter le programme")
		choice = 0		
		while choice!=1&&choice!=2&&choice!=3&&choice!=4
			print("\t\t>  ")
			choice = gets.chomp.to_i
			((choice!=1)&&(choice!=2)&&(choice!=3)&&(choice!=4)? puts("ERREUR, entrez un choix possible") : nil)
		end
		choice
	end

	def save_as_json
		File.open("db/emails_mairies.json","w+") {|k| k.write(JSON.pretty_generate(@data.to_json))}
	end

	def save_as_spreadsheet
		session = GoogleDrive::Session.from_config("config.json")
		worksheet = session.spreadsheet_by_key("15nmCYNSi2appmyW1kBuUiNMpPOnDR4drmaI7pv9TKUY").worksheets[0]
		@data.each_with_index do |hash_elmt, index| 
			worksheet[index+1,1] = hash_elmt.keys[0] 
			worksheet[index+1,2] = hash_elmt.values[0]
		end
		worksheet.save
	end

	def save_as_csv
		compteur = 0
		CSV.open("db/emails_mairies.csv", "w+") do |csv|
			csv << [@data]
		end
	end

	def main_loop(choice)
		if (choice != 4)
			puts("The programm is collecting your data\nBe patient, it may take a while")
			@data = Scrapper.new.perform
		end
		loop do
			case choice
				when 1
					save_as_json
					Done.new
				when 2
					save_as_spreadsheet
					Done.new
				when 3
					save_as_csv
					Done.new
				when 4
					exit
			end
			choice = lets_choose
		end
	end

	def initialize
		main_loop(lets_choose)
	end

end
