# High-Dimensional Macroeconomic Forecasting using Message Passing Algorithms

This repository contains MATLAB code to replicate all empirical results from the paper on high-dimensional macroeconomic forecasting using Generalized Approximate Message Passing (GAMP) algorithms.

## Paper

**Citation**: Korobilis, D. (2020). "High-dimensional macroeconomic forecasting using message passing algorithms," *Journal of Business and Economic Statistics*, 38(3), 493-504.

**DOI**: [10.1080/07350015.2018.1537912](https://doi.org/10.1080/07350015.2018.1537912)

**Abstract**: This paper introduces Generalized Approximate Message Passing (GAMP) algorithms to macroeconomic forecasting problems with many predictors, providing computationally efficient alternatives to traditional shrinkage methods like LASSO and Ridge regression.

## Repository Structure

```
high-dimensional-forecasting-gamp/
├── README.md                           # This file
├── LICENSE
├── JBES/                              # Main paper replication
│   ├── README.md                      # Detailed replication instructions
│   ├── FORECASTING/                   # Empirical forecasting exercises
│   │   ├── FORECASTING_UR.m          # Equation (37) - Tables 1 & 2
│   │   └── FORECASTING.m             # Equation (38) - Table 3
│   ├── APPENDIX_C/                    # Monte Carlo simulations (Online Appendix C)
│   │   ├── MONTE_CARLO_TVP/          # Time-variation forms
│   │   ├── MONTE_CARLO_REG/          # Static regression shrinkage
│   │   └── MONTE_CARLO_AR/           # AR(4) likelihood estimation
│   └── APPENDIX_D/                    # Volatility exercises (Online Appendix D)
│       └── VOLATILITY_ESTIMATES.m    # Figures D.1 and D.2
└── DEMO/                              # Tutorial code (2017 working paper)
    ├── README.md                      # Simple example instructions
    ├── MONTE_CARLO.m                  # Univariate regression demonstration
    └── functions/                     # Core GAMP algorithm functions
```

## Code Packages

### 1. JBES Package - Complete Paper Replication

**Location**: [`JBES/`](JBES/)

**Purpose**: Replicates all results in Korobilis (2020) "High-Dimensional Macroeconomic Forecasting Using Message Passing Algorithms" and the accompanying online appendix.

#### Main Empirical Results (FORECASTING folder)

**FORECASTING_UR.m**
- Estimates and forecasts using specification in equation (37)
- **Replicates**: Tables 1 & 2 in main paper
- Provides Mean Squared Forecast Errors (MSFEs) and log Predictive Likelihoods (logPLs)

**FORECASTING.m**
- Estimates and forecasts using specification in equation (38)  
- **Replicates**: Table 3 in main paper
- Provides MSFEs and logPLs for comparison

**Post-Processing Results**:
After running the forecasting codes, use these commands to obtain paper results:

```matlab
% Get relative MSFEs (relative to AR(1) benchmark)
mean(MSFE)./mean(MSFE(:,1))

% Get relative log Average Predictive Likelihoods
mean(logPL) - mean(logPL(:,1))

% Get cumulative forecast errors for Figures D.3 and D.4
cumsum(MSFE)
```

#### Monte Carlo Studies (APPENDIX_C folder)

**MONTE_CARLO_TVP/**
- Examines different forms of time-variation in parameters
- Run `MONTE_CARLO.m` for main simulations

**MONTE_CARLO_REG/** 
- Examines GAMP performance in shrinking exogenous predictors in static regression
- Run `MONTE_CARLO.m` for main simulations

**MONTE_CARLO_AR/**
- Examines GAMP ability as an estimator in AR(4) likelihood
- Run `MONTE_CARLO.m` for main simulations

*Note: Each subfolder includes functions to create the boxplots shown in Online Appendix C*

#### Volatility Analysis (APPENDIX_D folder)

**VOLATILITY_ESTIMATES.m**
- Replicates exercises in Online Appendix D.1
- **Generates**: Figures D.1 and D.2

### 2. DEMO Package - Tutorial Implementation

**Location**: [`DEMO/`](DEMO/)

**Purpose**: User-friendly demonstration of GAMP algorithms in simple settings, based on the 2017 working paper version.

**MONTE_CARLO.m**
- Demonstrates GAMP in simple univariate regressions with many predictors
- More accessible for users new to message passing algorithms
- Based on Monte Carlo studies from 2017 working paper

**functions/**
- Core GAMP algorithm implementations
- Helper functions for the tutorial examples

## Quick Start

### Requirements
- MATLAB R2016b or later
- Statistics and Machine Learning Toolbox
- Signal Processing Toolbox (for some functions)

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/[username]/high-dimensional-forecasting-gamp.git
   cd high-dimensional-forecasting-gamp
   ```

2. Add paths in MATLAB:
   ```matlab
   addpath(genpath('.'))
   ```

### Running the Code

#### For Beginners - Start with GAMP Tutorial
```matlab
cd GAMP
run MONTE_CARLO.m  % Simple demonstration of GAMP
```

#### Main Paper Results - JBES Package

**Replicate Main Forecasting Results:**
```matlab
cd JBES/FORECASTING

% For Tables 1 & 2
run FORECASTING_UR.m
rel_MSFE_12 = mean(MSFE)./mean(MSFE(:,1));
rel_logPL_12 = mean(logPL) - mean(logPL(:,1));

% For Table 3  
run FORECASTING.m
rel_MSFE_3 = mean(MSFE)./mean(MSFE(:,1));
rel_logPL_3 = mean(logPL) - mean(logPL(:,1));
```

**Replicate Monte Carlo Studies:**
```matlab
cd JBES/APPENDIX_C

% Time-varying parameters study
cd MONTE_CARLO_TVP
run MONTE_CARLO.m

% Static regression study  
cd ../MONTE_CARLO_REG
run MONTE_CARLO.m

% AR(4) likelihood study
cd ../MONTE_CARLO_AR
run MONTE_CARLO.m
```

**Replicate Volatility Analysis:**
```matlab
cd JBES/APPENDIX_D
run VOLATILITY_ESTIMATES.m  % Generates Figures D.1 and D.2
```

## Method Overview

**Generalized Approximate Message Passing (GAMP)** is a computationally efficient algorithm for high-dimensional statistical inference problems. In the context of macroeconomic forecasting:

- **Handles many predictors**: Efficiently processes datasets where the number of predictors approaches or exceeds the number of observations
- **Automatic shrinkage**: Provides data-driven shrinkage without requiring cross-validation for hyperparameter tuning  
- **Fast computation**: Significantly faster than traditional penalized regression methods
- **Uncertainty quantification**: Provides approximate posterior distributions for parameters

## Data Requirements

The empirical applications use standard macroeconomic datasets:
- **FRED-MD**: Federal Reserve Economic Data for monthly variables
- **Real-time data**: Vintages available from Federal Reserve Bank of Philadelphia
- **International data**: For multi-country exercises

*Note: Data files are not included due to licensing restrictions. Users should download data from original sources. See individual folder READMEs for specific data requirements.*

## Computational Notes

- **Runtime**: Monte Carlo exercises may take several hours depending on system specifications
- **Memory**: Large-scale forecasting exercises are memory intensive
- **Parallel Computing**: Consider using Parallel Computing Toolbox for faster execution
- **Convergence**: GAMP algorithms include convergence diagnostics and adaptive damping

## Citation

If you use this code in your research, please cite:

```
Korobilis, D. (2020). High-dimensional macroeconomic forecasting using message passing algorithms. 
Journal of Business and Economic Statistics, 38(3), 493-504.
```

## Related Work

This code complements other high-dimensional forecasting methods:
- Bayesian Variable Selection
- LASSO and Ridge regression  
- Factor models (PCA, dynamic factor models)
- Spike-and-slab priors

## License

This code is released under the MIT License. See [LICENSE](LICENSE) for details.

## Author

**Dimitris Korobilis**  
University of Glasgow  
Email: dimitris.korobilis@glasgow.ac.uk

## Issues and Support

Please report any issues or bugs through the GitHub issue tracker. For methodological questions, refer to the original paper or contact the author.

---

*This repository provides research code for academic purposes. While we strive for accuracy, please verify results for your specific applications.*
