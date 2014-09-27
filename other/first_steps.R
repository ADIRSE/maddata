library(XML)
table <- readHTMLTable("madrid.xls")
library (plyr)
df <- ldply (table, data.frame)
df
write.csv2(file="output_madrid.csv", x=df)

# data.frame(t(sapply(table,c)))


require(devtools)
install_github("rCharts", "ramnathv")


require(rCharts)
YEAR = 2011
# Step 1. create subsets of data by gender
men   <- subset(dat2m, gender == "Men" & year == YEAR)
women <- subset(dat2m, gender == "Women" & year == YEAR)

# Step 2. initialize bar plot for value by countrycode for women
p1 <- rPlot(x = list(var = "countrycode", sort = "value"), y = "value", 
            color = 'gender', data = women, type = 'bar')

# Step 3. add a second layer for men, displayed as points
p1$layer(x = "countrycode", y = "value", color = 'gender', 
         data = men, type = 'point', size = list(const = 3))

# Step 4. format the x and y axis labels
p1$guides(x = list(title = "", ticks = unique(men$countrycode)))
p1$guides(y = list(title = "", max = 18))

# Step 5. set the width and height of the plot and attach it to the dom
p1$addParams(width = 600, height = 300, dom = 'chart1',
             title = "Percentage of Employed who are Senior Managers")

# Step 6. print the chart (just type p1 if you are using it in your R console)
p1$print()


COUNTRY = "Canada"
country = subset(dat2m, country == COUNTRY)
p2 <- rPlot(value ~ year, color = 'gender', type = 'line', data = country)
p2$addParams(width = 600, height = 300, dom = 'chart2')
p2$guides(y = list(min = 0, title = ""))
p2$print()

data_folder <- 'data'
read.csv()