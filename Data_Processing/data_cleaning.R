library("qdapRegex")

# READ DATA
con <- file("data/final/en_US/en_US.blogs.txt", open = "r")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("data/final/en_US/en_US.news.txt", open = "r")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("data/final/en_US/en_US.twitter.txt", open = "r")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# SAMPLE DATA

sample_size <- 0.15
# For reproducibility
set.seed(120)

sample_blogs <- sample(blogs, length(blogs) * sample_size, replace = FALSE)
sample_news <- sample(news, length(news) * sample_size, replace = FALSE)
sample_twitter <- sample(twitter, length(twitter) * sample_size, replace = FALSE)

# COMBINE DATA

combined_data <- c(sample_blogs, sample_news, sample_twitter)

# CLEAN DATA

combined_data <- rm_email(combined_data)
combined_data <- rm_url(combined_data)
combined_data <- rm_non_ascii(combined_data)
combined_data <- rm_default(combined_data, pattern = "[^A-Za-z ]")
combined_data <- tolower(combined_data)

# TOKENISATION

tokenised <- strsplit(combined_data, "\\s")

# SAVE DATA

saveRDS(combined_data, file = "data/cleaned_data.RDS")