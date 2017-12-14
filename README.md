# Sentiment-Analysis-R-Programming
This repository helps Data Analytics/Science Enthusiasts to carry out Lexicon based Sentiment Analysis on text derived from Twitter, Facebook and other data sources.

*This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.

*This work is inspired from various scripts and improved with several iterations.

*This code can be shared and re-used on any purpose except for commercial purposes.


![alt text](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)

#Sentiment Analysis using Twitter & Facebook
The code is well documented and differentiates specific platform orientated code.
##
#What is Sentiment Analysis

Sentiment analysis (sometimes known as opinion mining or emotion AI) refers to the use of natural language processing, text analysis,computational linguistics, and biometrics to systematically identify, extract, quantify, and study affective states and subjective information. Sentiment analysis is widely applied to voice of the customer materials such as reviews and survey responses, online and social media, and healthcare materials for applications that range from marketing to customer service to clinical medicine.

Generally speaking, sentiment analysis aims to determine the attitude of a speaker, writer, or other subject with respect to some topic or the overall contextual polarity or emotional reaction to a document, interaction, or event. It is a way to evaluate written or spoken language to determine if the expression is favorable, unfavorable, or neutral, and to what degree. The applications of sentiment analysis are broad and powerful. The ability to extract insights from social data is a practice that is being widely adopted by organisations across the world.

-------Let's get started-------

Steps to follow:

1) Setup an app in Twitter:
    https://apps.twitter.com

   Setup an app in Facebook:
    https://developers.facebook.com

2)  After creating an app in Twitter, save the following keys to somewhere safe on desktop for further use.

    consumerKey
    
    consumerSecret
    
    accessToken
    
    accessSecret
    

    After creating an app in Facebook, save the following keys to somewhere safe on desktop for further use.
    
    App ID
    
    App Secret

3) Install R and R Studio on your local machine.

    #Install R - https://www.r-project.org
    
    #Install R Studio - https://www.rstudio.com/products/rstudio/download/


4) Set working directory in R studio:
    eg: 
    
    For Windows machine
    setwd("C:/Users/chandrahas/Desktop/kaggle")

    For Mac
    setwd("C:\Users\chandrahas\Desktop\kaggle")

5) Install following packages:

    install.packages("twitteR")
    
    install.packages("Rfacebook")
    
    install.packages("plyr")
    
    install.packages("stringr")
    
    install.packages("ggplot2") 

6) Load the libraries using library() function

7) Get required data for analysis either from twitter using searchTwitter() function, or from facebook using getPage() & getPost().     Or you can read a csv with read.csv() function.

8) Clean the data and remove punctuations, digits, special characters, etc. Sentiment analysis performed on cleaned data set gives us better insights removing unncessary words.

9) Use the positive and negative words files to analysize sentiments.

10) Use the sentiment scores for any visualizations with ggplot() function.

Sample visualization using ggplot2

Twitter Data

![alt text](https://raw.githubusercontent.com/chandrahas-reddy/Sentiment-Analysis-R-Programming/master/Twitter/Rplot.jpeg)

Facebook Data

![alt text](https://raw.githubusercontent.com/chandrahas-reddy/Sentiment-Analysis-R-Programming/master/Facebook/Rplot_fb.jpeg)

11) Finally store this data into CSV for any further purposes. 

Happy Data Analysis!!
