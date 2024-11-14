# if we put # sign, R will not recognize it
# entering numeric data/value 1 into environment (named as a)

a <- 1
# to see data
a

# entering hello into environment (named as b)
# hello is character data, use single or double quote
b <- "hello world"
b

# Given names such a, b are not case sensitive


# entering multiple numeric data into environment (named as a.1)

a_1 <- c(22, 55, 26, 30, 42, 24)
a_1

# capital C will not work

# no space or unequal space between values will work

# entering multiple character data into environment (named as b.1)
b_1 <- c("m", "f", "m", "m", "f", "m")
b_1 
c_1 <- c(1, 2, 3, 4, 5, 6)
c_1

# creating data set named ‘practice’ using variable a.1, b.1, c.1
practice <- data.frame(age=a_1, gender=b_1, id=c_1)

# length of a_1, b_1, c_1 should be same
# giving name as ‘age’ using a_1
# giving name as ‘sex’ using b1
# giving name as ‘id’ using c_1

# data.frame is a function and should be typed as it is

# to know about the data

str(practice)

# to get summary statistics

summary(practice)

# to get summary statistics only for age

summary(practice$age)

# to see frequency distribution of variables
# we need to install a package called ‘plyr’

install.packages('dplyr')
library(dplyr)

# to see frequency distribution of age
dplyr::count(practice, age)
 
# to see frequency distribution of sex
dplyr::count(practice, gender)

#to see summary data

install.packages("vtable")
library(vtable)

st(practice)

#individual function can be used to get certain descriptives

sd(practice$age)

#sd is a function

# Export/save data ‘practice’ in csv format

# Where is the data going to go?

getwd()
setwd("/Users/location/...")   #### EDIT ME
 
write.csv(practice, file = "practice.csv")

test <- read.csv("data/test.csv", header = TRUE)

head(test,10)

tail(test,10)

# To know about data
str(test)
summary(test)

# keep selected variables age, gender, id in a new data set named ‘newdata’
newdata <- dplyr::select(test, age, gender, id)
str(newdata)

newdata_female <- dplyr::filter(test, gender == "f")
str(newdata_female)

# to see histogram

hist_age <- hist(test$age)
plot(hist_age)

#visualize your data using scatter plots

install.packages("ggplot2")
library(ggplot2)

## histogram for age
hist_age_ggplot <- ggplot(test, aes(age)) +
                    geom_histogram()
plot(hist_age_ggplot)

## scatter plot ldl1 and ldl2
# ldl1 and ldl2 are continuous variables

scatter_ldl <- ggplot(test, aes(x = ldl1, y = ldl2)) +
                  geom_point() 

plot(scatter_ldl)

## scatter plot ldl1 and ldl2 with a regression line

scatter_ldl_lm <- ggplot(test, aes(x = ldl1, y = ldl2)) +
  geom_point() +
  geom_smooth(method = "lm")

plot(scatter_ldl_lm)

### Save an image

ggsave(scatter_ldl_lm.pdf, plot = scatter_ldl, dpi = 300)
