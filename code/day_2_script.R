
# Importing data set in CSV file named ‘data1’

getwd()
data1 <- read.csv("data1.csv", header=TRUE)

# to see first 10 observations
head(data1,10)

#to see last 10 observations
tail(data1,10)

# Importing data set in CSV file named ‘data2’

data2 <- read.csv("data2.csv", header = TRUE)

# merging data1 and data2

install.packages("dplyr")
library(dplyr)

data1 <- dplyr::select(data1, id, sex, ethgrp, weight, age, cvd)
data2 <- dplyr::select(data2, id, stroke, smoking, Cancer, ldl1, ldl2, gender)

### joining data 
data_merge <- dplyr::full_join(data1, data2) 

data_merge1 <- dplyr::full_join(data1, data2, by = join_by(id))

data_merge2 <- dplyr::full_join(data1, data2,by = join_by(id == id))

### importing test data

getwd()
test <- read.csv("test.csv", header = TRUE)

##test

head(test,10)

tail(test,10)

# to create categorial variable ‘agecat’ using age

summary(test$age)

test <- test %>% 
          mutate(age_cat = case_when(
            age < 45 ~ "<45",
            age >= 45 & age < 50 ~ "45-49",
            age >= 50 & age < 59 ~ "50-59",
            age >= 60 & age < 65 ~ "60-64",  
            TRUE ~ "65+"
          ))

count(test, age_cat)

table(test$age, test$age_cat)

# Check frequency distribution of a categorical variable
# Cross tabulation
# Chi-square test

# Check frequency distribution of gender
table(test$gender)

# Cross tabulation of gender and stroke

table(test$gender, test$stroke)

# Chi-square test between gender and stroke

chisq.test(test$gender, test$stroke)

# Fishers exact test

fisher.test(test$gender, test$stroke)


# First, we check if data follow Normal distribution
# Normality test (if p>0.05: data are normally distributed)
# Want to compare mean ages between male and female

test_data_female <- filter(test, gender == "f")
shapiro.test(test_data_female$age)

test_data_male <- filter(test, gender == "m")
shapiro.test(test_data_male$age)

# Also check histogtam

hist_age_gender <- ggplot(test, aes(age)) +
  geom_histogram() + 
  facet_wrap(~ gender)

plot(hist_age_gender)

# t-test

help(t.test)
t.test(age ~ gender, data = test)

#check variance
var.test(age ~ gender, data = test)

# variances are equal based on the test

t.test(age ~ gender, data = test, var.equal = TRUE)

#non-parametric test if data are not normally distributed

wilcox.test(age ~ gender, data = test)

#paired t-test for two dependent samples

t.test(test$ldl1, test$ldl2, paired = TRUE)

# Pearson correlation coefficient

cor.test(test$ldl1, test$ldl2,  method = "pearson") 

#Spearman correlation coefficient

cor.test(test$ldl1, test$ldl2,  method = "spearman") 


# Conduct linear regression model between dependent and independent variables
# age is continuous, gender is categorical, ldl is continuous variable

linear_model <- lm(age ~ as.factor(gender) + ldl1, data = test)

summary(linear_model)

install.packages("gtsummary")
library(gtsummary)

tbl_regression(linear_model)

## logistic regression

logistic_model <- glm(Cancer ~ as.factor(gender) + ldl1 + smoking, data = test, family = "binomial")
summary(logistic_model)

## odds ratios and 95% CI (Old School Way)
exp(cbind(OR = coef(logistic_model), confint(logistic_model)))

tbl_regression(logistic_model, exponentiate = TRUE) 

# One-way ANOVA
# Pass arguments to aov() function for an ANOVA test

one_anova <- aov(age ~ ethgrp, data = test)
summary(one_anova)

# Non-parametric ANOVA

kruskal.test(age ~ ethgrp, data = test)

