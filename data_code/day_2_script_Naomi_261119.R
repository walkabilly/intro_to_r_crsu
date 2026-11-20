# Importing data set in CSV file named ‘dataset1’
getwd()
data1 <- read.csv("dataset1.csv", header=TRUE)

# to see first 10 observations
head(data1,10)

#to see last 10 observations
tail(data1,10)

# Importing data set in CSV file named ‘dataset2’
data2 <- read.csv("dataset2.csv", header = TRUE)

# merging data1 and data2
# install.packages('dplyr') if you do not have dplyr installed on your computer!
library(dplyr)

data1 <- dplyr::select(data1, id, sex, ethgrp, weight, age, cvd)
data2 <- dplyr::select(data2, id, stroke, smoking, Cancer, ldl1, ldl2, sex)

### joining data 
# full_join keeps all observations in x and y (returns all x rows followed by unmatched y rows)
data_merge <- dplyr::full_join(data1, data2) # if there's no 'by', common column names are used

data_merge1 <- dplyr::full_join(data1, data2, by = join_by(id)) # if we add 'by', common names will be displayed as column.x, column.y

data_merge2 <- dplyr::full_join(data1, data2,by = join_by(id == id)) #this is useful when column names are different

data_merge3 <- dplyr::full_join(data1, data2, by = join_by(id, sex)) #this matches rows using both id and sex (both must match for two rows to join)

### importing test data
getwd()
test <- read.csv("test.csv", header = TRUE)

##test
head(test,10)
tail(test,10)

# to create categorial variable ‘age_cat’ using age
summary(test$age)

# %>%: pipe operator from dplyr package: "applies the following" to left
# mutate: creates new columns or modifies existing columns
# case_when: using multiple conditions to assign values, left: condition & right: value to assign
              # checks conditions from top to bottom and uses the first match
test <- test %>% 
          mutate(age_cat = case_when(
            age < 45 ~ "<45",
            age >= 45 & age < 50 ~ "45-49",
            age >= 50 & age < 60 ~ "50-59",
            age >= 60 & age < 65 ~ "60-64",  
            TRUE ~ "65+" # all the other cases
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
chisq.test(test$gender, test$stroke) # here we test whether gender and stroke are associated

# Fishers exact test
fisher.test(test$gender, test$stroke) # here we test whether gender and stroke are associated

# Both test for association b/w cateogrical variables. Chi^2 uses approximation, Fisher is useful when cell counts are small

# First, we check if data follow Normal distribution
# Shapiro-Wilk test:
# p>0.05: do not reject the normality assumption
# Want to compare mean ages between male and female
test_data_female <- filter(test, gender == "f")
shapiro.test(test_data_female$age) # p>0.05, do not reject normality

test_data_male <- filter(test, gender == "m")
shapiro.test(test_data_male$age) # p<0.05, reject normality -> ages are not nomally distributed for male

# Also check histogtam
library(ggplot2)

hist_age_gender <- ggplot(test, aes(age)) +
  geom_histogram() + 
  facet_wrap(~ gender) # facet the plot with 'gender' variable

plot(hist_age_gender)

# t-test: checks whether the diff b/w means is statistically significant between groups
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

# install.packages("gtsummary")
library(gtsummary)

tbl_regression(linear_model)

## logistic regression
logistic_model <- glm(Cancer ~ as.factor(gender) + ldl1 + smoking, data = test, family = "binomial")
summary(logistic_model)

## odds ratios and 95% CI (Old School Way)
exp(cbind(OR = coef(logistic_model), confint(logistic_model)))
tbl_regression(logistic_model, exponentiate = TRUE) 

# One-way ANOVA
# One-way ANOVA tests whether the means differ across groups.
# H0: all group means are equal; a significant result suggests at least one differs.

# Pass arguments to aov() function for an ANOVA test
one_anova <- aov(age ~ ethgrp, data = test) # tests whether mean age differs across ethnic groups
summary(one_anova)

# Non-parametric ANOVA
kruskal.test(age ~ ethgrp, data = test)
