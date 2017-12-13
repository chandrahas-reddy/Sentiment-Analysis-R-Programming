#Lexicon based sentiment analysis on facebook data
#libraries required for Lexicon based sentiment analysis and visualization
install.packages("Rfacebook")
install.packages("plyr")
install.packages("stringr")
install.packages("ggplot2")

#loading the library
library(Rfacebook)
library(plyr)
library(stringr)
library(ggplot2)

#Facebook Authentication
#Creating a Facebook app is easy and many tutorials can be found online!
#please put in your authentication keys here

fb_auth <- fbOAuth(app_id="119027498778445", 
                    app_secret="53cc2540b464f0c3f52ae9e5f09aa4b2", 
                    extended_permissions = TRUE) 


#getting posts from a facebook page
fb_page <- getPage(page="manchesterunited", token=fb_auth, n = 10,  feed = FALSE, 
              reactions = TRUE,  verbose = TRUE, api = NULL)
#n=10 retrieves recent 10 posts from the facebook page 

#Let's view the data we retrieved and chose one post for our analysis
View(fb_page)

##
#I have chosen post of id 6 "Full time: United 1 AFC Bournemouth 0" post for the analysis as it has more user ineraction 
##

#Extract information of a certain post in the data we collected
fb_post <- getPost(post = fb_page$id[6], n=1000, token=fb_auth)
#n=1000; limiting our analysis to 1000 comments on the post

#converting to DataFrame
fb_post_df <- as.data.frame(fb_post[3])
View(fb_post_df)

###
###TextCleaning###
###

#for Mac or Unix OS
comments_data <- sapply(fb_post_df$comments.message, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))

#for Windows based OS
comments_data <- sapply(fb_post_df$comments.message,function(row) iconv(row, "latin1", "ASCII", sub=""))

#common for any platform
comments_data <- gsub("@\\w+", "", comments_data)
comments_data <- gsub("#\\w+", '', comments_data)
comments_data <- gsub("RT\\w+", "", comments_data)
comments_data <- gsub("http.*", "", comments_data)
comments_data <- gsub("RT", "", comments_data)
comments_data <- sub("([.-])|[[:punct:]]", "\\1", comments_data)
comments_data <- sub("(['])|[[:punct:]]", "\\1", comments_data)

#View the cleaned Data
View(comments_data)

#Reading the Lexicon positive and negative words
pos<-readLines("positive_words.txt")
neg<-readLines("negative_words.txt")

#function to calculate sentiment score
score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of postive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  
  # create simple array of scores with laply
  scores <- laply(sentences,
                function(sentence, pos.words, neg.words)
                {
                  # remove punctuation
                  sentence <- gsub("[[:punct:]]", "", sentence)
                  # remove control characters
                  sentence <- gsub("[[:cntrl:]]", "", sentence)
                  # remove digits
                  sentence <- gsub('\\d+', '', sentence)
                  
                  #convert to lower
                  sentence <- tolower(sentence)
                  
                  
                  # split sentence into words with str_split (stringr package)
                  word.list <- str_split(sentence, "\\s+")
                  words <- unlist(word.list)
                  
                  # compare words to the dictionaries of positive & negative terms
                  pos.matches <- match(words, pos)
                  neg.matches <- match(words, neg)
                  
                  # get the position of the matched term or NA
                  # we just want a TRUE/FALSE
                  pos.matches <- !is.na(pos.matches)
                  neg.matches <- !is.na(neg.matches)
                  
                  # final score
                  score <- sum(pos.matches) - sum(neg.matches)
                  return(score)
                }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df <- data.frame(text=sentences, score=scores)
  return(scores.df)
}

#sentiment score
score_fb <- score.sentiment(comments_data, pos, neg, .progress='text')
View(score_fb)

#Summary of the sentiment scores
summary(score_fb)

#Convert sentiment scores from numeric to character to enable the gsub function 
score_fb$score_chr <- as.character(score_fb$score)

#After looking at the summary(scores_twitter$score) decide on a threshold for the sentiment labels
score_fb$score_chr <- gsub("^0$", "Neutral", score_fb$score_chr)
score_fb$score_chr <- gsub("^1$|^2$|^3$|^4$", "Positive", score_fb$score_chr)
score_fb$score_chr <- gsub("^5$|^6$|^7$|^8$|^9$|^10$|^11$|^12$", "Very Positive", score_fb$score_chr)
score_fb$score_chr <- gsub("^-1$|^-2$|^-3$|^-4$", "Negative", score_fb$score_chr)
score_fb$score_chr <- gsub("^-5$|^-6$|^-7$|^-8$|^-9$|^-10$|^-11$|^-12$", "Very Negative", score_fb$score_chr)

View(score_fb)

#Convert score_chr to factor for visualizations
score_fb$score_chr<-as.factor(score_fb$score_chr)

#plot to show number of negative, positive and neutral comments
Viz1 <- ggplot(score_fb, aes(x=score_chr))+geom_bar()
Viz1

#writing to csv file
write.csv(score_fb, file = "manchester_united_sentiment_score.csv")

##This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.
##The above code is inspired from various scripts and improved with several iterations.
##This code can be shared and re-used on any purpose except for commercial purposes.