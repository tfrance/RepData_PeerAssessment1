# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

```r
# Create a directory to store the data:
if (!file.exists("data")) {
  dir.create("data")
}

# Unzip activity.zip into the data directory:
unzip("activity.zip", exdir="./data", overwrite=T)

# Read in the data:
data = read.csv("./data/activity.csv", colClasses=c("integer", "Date", "numeric"))
```

## What is mean total number of steps taken per day?

```r
# Create a data structure that sums daily steps by date:
data.groupedby.date = aggregate(steps ~ date, sum, data=data)

# Histogram of total daily steps
hist(data.groupedby.date$steps, xlab="Steps", main="Histogram of Total Steps per Day")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```r
# Calculate the mean and median of total daily steps taken
```

The mean total daily steps taken is 10766.

The median total daily steps taken is 10765

## What is the average daily activity pattern?

```r
# Create a data structure that finds average daily steps by time interval
data.groupedby.interval = aggregate(steps ~ interval, mean, data=data)
attach(data.groupedby.interval)
```

```
## The following objects are masked from data.groupedby.interval (position 11):
## 
##     interval, steps
## The following objects are masked from data.groupedby.interval (position 12):
## 
##     interval, steps
```

```r
# Plot the average daily steps by interval in a time series:
plot(interval, steps, type="l", xlab="Time Interval (5-minute)", ylab="Mean Daily Steps", main="Mean Daily Activity by 5-minute Interval")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

The maximum average number of steps is 206.1698, at interval 835.


```r
detach(data.groupedby.interval)
```

## Imputing missing values

The number of rows with missing data = 2304

Missing values will be re-coded according to the mean value of the corresponding interval


```r
library(plyr)

data.recoded <- data
# Function to replace NA values with computed mean
replace.na.with.mean <- function(x) {
  replace(x, is.na(x), mean(x, na.rm=TRUE))
}
data.recoded <- ddply(data, ~ interval, transform, steps=replace.na.with.mean(steps))
# Create a data structure that sums daily steps by date:
data.groupedby.date = aggregate(steps ~ date, sum, data=data.recoded)

# Histogram of total daily steps
hist(data.groupedby.date$steps, xlab="Steps", main="Histogram of Total Steps per Day")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

The mean total daily steps taken is 10766.

The median total daily steps taken is 10766

## Are there differences in activity patterns between weekdays and weekends?

Add a factor variable that assigns the values 'weekday' or 'weedend' to each row

```r
# Calculate the day of the week for each date
day<- function(date) {
  if (weekdays(date) %in% c("Saturday", "Sunday")) {
    "weekend"
  } else {
    "weekday"
  }
}
# Add a factor var 'day' to the data set
data$day <- as.factor(sapply(data$date, day))
```
Plot the average daily activity pattern for weekdays and weekends

```r
par(mfrow = c(2, 1))
for (type in c("weekend", "weekday")) {
    data.groupedby.day.interval = aggregate(steps ~ interval, mean, data=data, subset=data$day == type)
    plot(data.groupedby.day.interval, type = "l", main = type)
}
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 

