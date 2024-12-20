library(readr)
library(dplyr)
library(ggplot2)

inventory_data <- read_csv("D:/Scrips, Codes & Programming/Data Analysis/TABLEAU PROJECTS/supplychainoptimization.csv")

# str(inventory_data)
# head(inventory_data)
# summary(inventory_data)

# colSums(is.na(inventory_data))
# sum(duplicated(inventory_data))

# data check 

str(inventory_data)  # structure of data
head(inventory_data) # first few rows for sanity check
summary(inventory_data) # summary stats for the columns

# missing/duplicates check

colSums(is.na(inventory_data))  
sum(duplicated(inventory_data)) 

# demand distribution 

ggplot(inventory_data, aes(x = Demand)) +
  geom_histogram(binwidth = 20, fill = "blue", alpha = 0.7) +
  labs(
    title = "Demand Distribution",
    x = "Demand",
    y = "Frequency"
  )

# lead time distrib 

ggplot(inventory_data, aes(x = Lead_Time_Days)) +
  geom_histogram(binwidth = 2, fill = "green", alpha = 0.7) +
  labs(
    title = "Lead Time Distribution",
    x = "Lead Time (Days)",
    y = "Frequency"
  )

# monthly demand aggregation

monthly_demand <- inventory_data %>%
  group_by(Month) %>%  # Use the correct case for 'Month'
  summarise(total_demand = sum(Demand))  # sum per month

# plotting

ggplot(monthly_demand, aes(x = Month, y = total_demand)) +
  geom_line(color = "blue") +
  labs(
    title = "Monthly Total Demand",
    x = "Month",
    y = "Total Demand"
  )

# supplier analysis

supplier_analysis <- inventory_data %>%
  group_by(Supplier) %>%  # Use the correct case for 'Supplier'
  summarise(
    avg_lead_time = mean(Lead_Time_Days),  # avg lead time per supplier
    total_cost_contribution = sum(Cost * Demand)  # supplier contribution by cost
  )

# visualize supplier lead times

ggplot(supplier_analysis, aes(x = reorder(Supplier, avg_lead_time), y = avg_lead_time)) +
  geom_bar(stat = "identity", fill = "purple") +
  coord_flip() +  # flip for better readability
  labs(
    title = "Lead Time by Supplier",
    x = "Supplier",
    y = "Average Lead Time (Days)"
  )

# eoq + reorder pts

inventory_data <- inventory_data %>%
  mutate(
    eoq = sqrt((2 * Demand * 50) / 2),  # EOQ formula (ordering cost=50, holding cost=2)
    reorder_point = (Lead_Time_Days * Demand / 30) + Safety_Stock  # reorder point formula
  )

# final check on enriched data

head(inventory_data)  # quick preview of added columns

# saving

write_csv(inventory_data, "optimized_inventory_dataset.csv")
