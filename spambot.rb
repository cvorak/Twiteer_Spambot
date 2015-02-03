require 'jumpstart_auth'

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

	def everyones_last_tweet
		friends = @client.friends
		friends.each do |friend|
			puts "#{friend.screen_name} said..."
			puts "#{friend.status.source}"
		puts
		end
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
				else
				puts "Sorry, I don't know how to #{command}"
			end 
		end
	end


end

blogger = MicroBlogger.new
blogger.run
