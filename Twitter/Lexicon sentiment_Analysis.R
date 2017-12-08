#Lexicon based sentiment analysis on twitter data
#libraries required for Lexicon based sentiment analysis and visualization
install.packages("twitteR")
install.packages("plyr")
install.packages("stringr")
install.packages("ggplot2")
#loading the library
library(twitteR)
library(plyr)
library(stringr)
library(ggplot2)

#Twitter Authentication
#Creating a twitter app is easy and many tutorials can be found online!
#please put in your authentication keys here

consumerKey <- "O2FmvX2WaegyWhmW9********"
consumerSecret <- "zelDESCaOFc2LvQoGSuta9ExIXhFLwSeERwEYQDT**********"
accessToken <- 	"1941789895-QLKNfqZinj8NsbKioY74tecH4nmly**********"
accessSecret <- "U8dD6zi6sflwKWQONAk3sN78mb0gf8ZPt23**********"

setup_twitter_oauth(consumer_key = consumerKey, 
                    consumer_secret = consumerSecret, 
                    access_token = accessToken, 
                    access_secret = accessSecret)

#SearchTwitter
twitter.data<-searchTwitter("Manchester United", n=1000,  lang='en')
#n=1000 gives us 1000 tweets

#We can either search from twitter or use an existing data file.
twitter.data.df <- read.csv("data.csv")

#Conversion to data frame
twitter.data.df<-twListToDF(twitter.data)

#GetText
tweets.df<-as.data.frame(twitter.data.df$text)
colnames(tweets.df)[1]<-"text"

###
###TextCleaning###
###

#for Mac or Unix OS
tweets.df <- sapply(tweets.df$text, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))

#for Windows based OS
tweets.df <- sapply(tweets.df,function(row) iconv(row, "latin1", "ASCII", sub=""))

#common for any platform
tweets.df<-gsub("@\\w+", "", tweets.df)
tweets.df<-gsub("#\\w+", '', tweets.df)
tweets.df<-gsub("RT\\w+", "", tweets.df)
tweets.df<-gsub("http.*", "", tweets.df)
tweets.df<-gsub("RT", "", tweets.df)
tweets.df <- sub("([.-])|[[:punct:]]", "\\1", tweets.df)
tweets.df <- sub("(['])|[[:punct:]]", "\\1", tweets.df)

#View the cleaned Data
View(tweets.df)

#Reading the Lexicon positive and negative words
pos<-readLines("positive_words.txt")
neg<-readLines("negative_words.txt")

#function to calculate sentiment score
score.sentiment<-function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of postive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  
  # create simple array of scores with laply
  scores<-laply(sentences,
                function(sentence, pos.words, neg.words)
                {
                  # remove punctuation
                  sentence<-gsub("[[:punct:]]", "", sentence)
                  # remove control characters
                  sentence<-gsub("[[:cntrl:]]", "", sentence)
                  # remove digits
                  sentence<-gsub('\\d+', '', sentence)
                  
                  #convert to lower
                  sentence<-tolower(sentence)
                  
                  
                  # split sentence into words with str_split (stringr package)
                  word.list<- str_split(sentence, "\\s+")
                  words<- unlist(word.list)
                  
                  # compare words to the dictionaries of positive & negative terms
                  pos.matches<-match(words, pos)
                  neg.matches<- match(words, neg)
                  
                  # get the position of the matched term or NA
                  # we just want a TRUE/FALSE
                  pos.matches<- !is.na(pos.matches)
                  neg.matches<- !is.na(neg.matches)
                  
                  # final score
                  score<- sum(pos.matches) - sum(neg.matches)
                  return(score)
                }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df<- data.frame(text=sentences, score=scores)
  return(scores.df)
}
#sentiment score
scores_twitter<-score.sentiment(tweets.df, pos, neg, .progress='text')
View(scores_twitter)

#Summary of the sentiment scores
summary(scores_twitter)

#Convert sentiment scores from numeric to character to enable the gsub function 
scores_twitter$score_chr<-as.character(scores_twitter$score)

#After looking at the summary(scores_twitter$score) decide on a threshold for the sentiment labels
scores_twitter$score_chr<-gsub("^0$", "Neutral", scores_twitter$score_chr)
scores_twitter$score_chr<-gsub("^1$|^2$|^3$|^4$", "Positive", scores_twitter$score_chr)
scores_twitter$score_chr<-gsub("^5$|^6$|^7$|^8$|^9$|^10$|^11$|^12$", "Very Positive", scores_twitter$score_chr)
scores_twitter$score_chr<-gsub("^-1$|^-2$|^-3$|^-4$", "Negative", scores_twitter$score_chr)
scores_twitter$score_chr<-gsub("^-5$|^-6$|^-7$|^-8$|^-9$|^-10$|^-11$|^-12$", "Very Negative", scores_twitter$score_chr)

View(scores_twitter)

#Convert score_chr to factor for visualizations
scores_twitter$score_chr<-as.factor(scores_twitter$score_chr)

#plot to show number of negative, positive and neutral comments
Viz1 <- ggplot(scores_twitter, aes(x=score_chr))+geom_bar()
Viz1

#writing to csv file
write.csv(scores_twitter, file = "manchester_united_sentiment_score.csv")

##This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.
##The above code is inspired from various scripts and improved with several iterations.
##This code can be shared and re-used on any purpose.
##Not for commercial purposes.