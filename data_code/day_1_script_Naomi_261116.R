### Make sure your R Project and all the files are in the same folder!

# if we put # sign, R will not recognize it
# entering numeric data/value 1 into environment (named as a)

a <- 1
# to see data
a

# entering hello into environment (named as b)
# hello is character data, use single or double quote
b <- "hello world"
b

# Given names such a, b are case sensitive
a
A # This is going to return an Error saying no object A is found
b
B # Same error as A because we haven't defined 'B', but only defined 'b'

# entering multiple numeric data into environment (named as a_1)

a_1 <- c(22, 55, 26, 30, 42, 24)
a_1
# capital C will not work. if you gen an error saying in `contrasts<-` ~~~, make sure you are using small c, not upper case C

# no space or unequal space between values will work

# entering multiple character data into environment (named as b_1 and c_1)
b_1 <- c("m", "f", "m", "m", "f", "m")
b_1 
c_1 <- c(1, 2, 3, 4, 5, 6)
c_1

abc <- 22
abcd <- "22"
class(abc) #number
class(abcd) #character


rm(abc, abcd) # you can delete values or data from your working environment with rm() 

# creating data set named ‘practice’ using variable a_1, b_1, c_1
practice <- data.frame(age=a_1, gender=b_1, id=c_1)

# length of a_1, b_1, c_1 should be same
# giving name as ‘age’ using a_1
# giving name as ‘gender’ using b1
# giving name as ‘id’ using c_1

# data.frame is a function and should be typed as it is

# to know about the data

str(practice)

# to get summary statistics

summary(practice)

# to get summary statistics only for age

summary(practice$age)

# what if we use cbind (rbind)? cbind -> bind columns, rbind -> bind rows
practice_r <- cbind(a_1, b_1, c_1)

str(practice_r) # with cbind, the matrix can only have one data type, and thus numeric values become character
str(practice)   # data frame preserves each column's data type

summary(practice)
summary(practice_r) 

summary(practice$age)
summary(practice_r$a_1)       # error! why? $ cannot be used with this matrix
summary(practice_r[ , "a_1"]) # matrix column: stored as character
summary(a_1)                  # original column: still numeric

# to see frequency distribution of variables
# we need to install a package called ‘dplyr’

install.packages('dplyr') # '' and "" both works! preference thing
library(dplyr)

# to see frequency distribution of age
dplyr::count(practice, age)
 
# to see frequency distribution of gender
dplyr::count(practice, gender)

# Compare each value with 30
age >= 30
practice$age >= 30

attach(practice) #attach is letting R know that you are using that specific data now 
# sometimes convenient, but not recommended if you are still cleaning data, or working with multiple data
age>=30

detach(practice)

# But we need to be careful about attach because it does not reflect changes
# illustration below
prac <- data.frame(age = c(22, 55, 26))
attach(prac)

prac$age <- prac$age + 1
prac$age
age
detach(prac)
rm(prac)

# Use the condition to select rows
dplyr::filter(practice, age >= 30) # Here, you are not saving filtered data, dplyr:: here means you are using 'filter' from 'dplyr' package. Not necessary

# Combine two conditions
dplyr::filter(practice, age >= 30 & gender == "f")

# Create a logical variable
practice$age_30_plus <- practice$age >= 30

practice
table(practice$age_30_plus)

# Select columns: keep only age and id
subset <- dplyr::select(practice, age, id)

# --- Your turn! (5 minutes) ---
# Using the practice dataset:
# 1. Filter participants younger than 40.
# 2. Keep only the age and id columns.
# 3. Save the result as practice_under40.
# 4. Display your new dataset.

# Write your code below:



### Answer
# Exercise 1
practice_under40 <- dplyr::filter(practice, age < 40) # don't forget save your filter
practice_under40 <- dplyr::select(practice_under40, age, id) # filter, than select
practice_under40

#to see summary data

install.packages("vtable")
library(vtable)

st(practice)

#individual function can be used to get certain descriptives

sd(practice$age)

#sd is a function

# what if we having missing data?
x <- c(22, NA, 30)

is.na(x)                 # Which value is missing?
mean(x)                 # Returns NA
mean(x, na.rm = TRUE)   # Excludes missing values

?mean

# Export/save data ‘practice’ in csv format

# Where is the data going to go?

getwd()
# setwd("/Users/location/...")   #### EDIT ME

?write.csv
write.csv(practice, file = "practice.csv")
write.csv(practice, "practice.csv", row.names = FALSE)

?read.csv
test <- read.csv("test.csv", header = TRUE)

head(test)    # First few rows
dim(test)     # Number of rows and columns
names(test)   # Column names
str(test)     # Structure and variable types
tail(test)    # Last few rows

head(test,10)
tail(test,10)

# To know about data
str(test)
summary(test)

# keep selected variables age, gender, id in a new data set named ‘newdata’
newdata <- dplyr::select(test, age, gender, id)
str(newdata)

newdata_female <- dplyr::filter(test, gender == "f")   ## Sidebar on logical operators (https://bookdown.org/rwnahhas/IntroToR/logical.html)
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

hist_age_ggplot +
  labs(title = "Distribution of Age")

plot(hist_age_ggplot) # it returns to original figure without the title because we did not update the plot object itself!

hist_age_ggplot <- hist_age_ggplot +
  labs(title = "Distribution of Age")

plot(hist_age_ggplot) # now it works!

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

ggsave("scatter_ldl_lm.pdf", plot = scatter_ldl_lm, dpi = 300)

# --- Your turn! (5–7 minutes) ---
# Using the test dataset:
# 1. Create a histogram of ldl1 using ggplot().
# 2. Add the title "Distribution of LDL1".
# 3. Save the plot as "ldl1_histogram.png".

# Hint: Add a title using + labs(title = "Your title")

# Write your code below:
