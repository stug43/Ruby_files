require "nokogiri"
require "open-uri"
require "pry"

class Scrapper
	attr_accessor :page, :scrapped_data

	def initialize(url="http://www.annuaire-des-mairies.com/")
		@page = Nokogiri::HTML(open(url))
	end

	def liste_dpts(page)
		liste_dpts = page.css("//tbody//tr//td//a[@class='lientxt']/@href").to_a
		liste_dpts.map! {|k| k.text}
	end

	def get_townhall_urls(liste_dpts,page)
		liste_cmmnes = []
		liste_noms = []
		nbpagescommunes = []
		liste_dpts.map do |lien|
			page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+lien))
			nbpagescommunes += page.css("/html/body/table/tbody/tr[3]/td/table/tbody/tr/td[1]/p[4]//a/@href").to_a
			nbpages = 0
			while nbpages < nbpagescommunes.size+1
				if nbpagescommunes.size > 0
					page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+nbpagescommunes[nbpages])) 
				end
				liste_cmmnes += page.css("//p/a.lientxt/@href").to_a
				liste_noms += page.css("//p/a.lientxt/text()").to_a.map! {|k| k.text}
				nbpages += 1
			end
		end
		return [liste_noms, liste_cmmnes.map! {|k| k.text}]
	end

	def scrapping_method(arraydarrays)
		email_array = []
		arraydarrays[1].map do |k|
			begin
					page =  Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/"+k))
					email_array << page.css("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
			rescue StandardError, OpenURI::HTTPError
					puts "ERROR"
			end
		end
		@scrapped_data = [arraydarrays[0], email_array].transpose.map {|k| [k].to_h}
		return self.scrapped_data
	end

	def perform(page=@page)
		return scrapping_method(get_townhall_urls(["val-d-oise.html"],page))
	end
		
end
