# Create a directory to store the data:
if (!file.exists("data")) {
  dir.create("data")
}

# Unzip activity.zip into the data directory:
unzip("activity.zip", exdir="./data", overwrite=T)

# Read in the data:
data = read.csv("./data/activity.csv")

# Group the data by date:
data.groupedby.date = aggregate(steps ~ date, sum, data=data)

# Histogram of total daily steps
hist(data.groupedby.date$steps)

# Calculate the mean and median of total daily steps taken
mean(data.groupedby.date$steps)
median(data.groupedby.date$steps)
