class Done
	
	def its_over_method
		puts
		2.times {puts("\t"+"#"*53)}
		2.times {puts("\t"+"#"+" "*51+"#")}
		puts("\t"+"#"+" "*21+"IT'S DONE"+" "*21+"#")
		2.times {puts("\t"+"#"+" "*51+"#")}
		puts("\t"+"#"*53)
		puts
	end

	def initialize
		its_over_method
	end

end
		
