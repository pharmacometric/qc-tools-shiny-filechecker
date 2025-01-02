library(ggplot2)
library(dplyr)
library(tidyr)
librar(survival)
library(survminer)

# Set seed for reproducibility
set.seed(123)

# Parameters for the pharmacokinetic model
Cmax <- 100  # ug/L
Tmax <- 17   # hours
half_life <- 20  # hours
bioavailability <- 0.8  # 80%

# Generate time points
time_points <- seq(0, 72, by = 1)  # 0 to 72 hours

# Two-compartment model equation
pk_model <- function(t, Cmax, Tmax, half_life) {
  k_elim <- log(2) / half_life
  C <- (Cmax * (Tmax / (Tmax + t)) * exp(-k_elim * t))
  return(C)
}

# Simulate data for 105 patients
n_patients <- 105
patient_data <- data.frame(
  Patient_ID = 1:n_patients,
  Concentration = sapply(time_points, function(t) pk_model(t, Cmax, Tmax, half_life) +
                           rnorm(n_patients, mean = 0, sd = 5))  # Adding some noise
)

# Reshape the data for plotting
long_patient_data <- patient_data %>%
  pivot_longer(-Patient_ID, names_to = "Time", values_to = "Concentration") %>%
  mutate(Time = as.numeric(gsub("Concentration", "", Time)))

# Calculate median and 90% confidence interval
summary_data <- long_patient_data %>%
  group_by(Time) %>%
  summarise(
    Median = median(Concentration),
    CI_lower = quantile(Concentration, 0.05),
    CI_upper = quantile(Concentration, 0.95)
  )

# Concentration vs Time plot
pk_plot <- ggplot(summary_data, aes(x = Time)) +
  geom_line(aes(y = Median), color = "blue") +
  geom_ribbon(aes(ymin = CI_lower, ymax = CI_upper), alpha = 0.2, fill = "lightblue") +
  labs(title = "Concentration vs Time for Drug AA",
       x = "Time (hours)",
       y = "Concentration (ug/L)") +
  theme_minimal()

# Save the concentration vs time plot
ggsave("Concentration_vs_Time_AA.png", plot = pk_plot, width = 8, height = 6)

# Generate Kaplan-Meier data
n_survival_patients <- 87
survival_data <- data.frame(
  Time = rexp(n_survival_patients, rate = 0.1),
  Status = sample(c(0, 1), n_survival_patients, replace = TRUE, prob = c(0.7, 0.3))  # 0 = censored, 1 = event
)

# Fit the Kaplan-Meier model
km_fit <- survfit(Surv(Time, Status) ~ 1, data = survival_data)

# Kaplan-Meier plot
km_plot <- ggsurvplot(km_fit,
                      data = survival_data,
                      title = "Kaplan-Meier Survival Curve",
                      xlab = "Time (days)",
                      ylab = "Survival Probability",
                      risk.table = TRUE,
                      palette = "Dark2")

# Save the Kaplan-Meier plot
ggsave("Kaplan_Meier_Survival_Curve.png", plot = km_plot$plot, width = 8, height = 6)

# Print messages
print("Plots have been saved as 'Concentration_vs_Time_AA.png' and 'Kaplan_Meier_Survival_Curve.png'.")
