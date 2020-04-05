# string splitting
pangram <- "The quick brown fox jumps over the lazy dog"
words <- strsplit(pangram, " ")[[1]] # if remove [[1]] it will be list
words[1] # The
class(words) # character

# string concatination
tmp = paste("Hello", "world", sep = " ")
tmp
class(tmp)