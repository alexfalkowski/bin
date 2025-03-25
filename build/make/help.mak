default: help

# Show this help.
help:
	@cat $(MAKEFILE_LIST) | ruby -e "input = ARGF.read; indent = input.scan(/^\w[^:]*:/).map(&:size).max / 3; puts \"\nUsage: make \033[32m<command>\033[0m [arg1=value1] [arg2=value2]\n\nCommands:\n\", input.scan(/((?:^# .+\n)+)^([^:]+):/).map { |comments, command| \"\n \033[32m#{command.ljust indent}\033[0m#{comments.lines.first.strip}#{comments.lines[1..-1].map { |comment| \"\n \" + ' ' * indent + comment }.join}\".gsub(/\`.+?\`/) { |code| \"\033[36m#{code}\033[0m\" } }, ''"
