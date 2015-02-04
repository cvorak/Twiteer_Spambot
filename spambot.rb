require 'jumpstart_auth'
require 'bitly'


class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "WARNING!!! Messages can be only 140 characters long."
		end	
	end

	def dm(target, message)
 		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
 		puts "Trying to send #{target} this direct message:"
  		puts message
  		message = "d @#{target} #{message}"
  		if screen_names.include? target
  			tweet(message)
  		else
  			puts "You can only DM people who follow you :("
  		end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		return screen_names
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each do |follower|
			dm(follower, message)
		end
	end

	# didn't do the friends sort, because I really don't see the point
	def everyones_last_tweet
		followers = @client.followers.collect { |follower| @client.user(follower) }
		followers.each do |follower|
			puts "#{follower.screen_name} said at #{follower.status.created_at.strftime("%A, %b %d")}..."
			puts follower.status.text
			puts
		end
	end

	def shorten(original_url)
		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		puts "Shortening this URL: #{original_url}"
		return bitly.shorten(original_url).short_url
	end
	
	def run
		puts "Welcome to Twitter spambot!"
		command = ""
		while command != 'q'
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'last' then everyones_last_tweet
				when 's' then shorten(parts[1])
				else
				puts "Sorry, I don't know how to #{command}"
			end 
		end
	end


end

blogger = MicroBlogger.new
blogger.run
