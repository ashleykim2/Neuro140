# Neuro140

# Automated BiGaussian Fitting for Auditory PSTH Data

This repository contains a MATLAB pipeline for automated fitting of biGaussian models to neural peri-stimulus time histograms (PSTHs) recorded from auditory brainstem stimulation experiments. The pipeline enables scalable, reproducible analysis of early and late neural response components across multiple electrodes and stimulation levels.

## 📂 Project Structure

- `automatedGaussianFit.m`: Core script that preprocesses PSTH data, fits biGaussian models to each level × channel combination, and stores fit parameters in `autoFitResults.mat`. Also includes an example visualization of one fitted PSTH.
- `plotAllChannelsWithFits.m`: Loads saved fit results and creates overlay plots of early and late Gaussian fits across all stimulation levels for each of the 16 channels. Each channel is saved as a separate `.png` file in a `channel_fit_figures/` folder.
- `generatePlot.m`: Plots PSTHs across all 16 channels using color-coded levels for quick visual inspection. Used to generate Figure 1 in the final report.
- `plotHistPeriod.m`: A helper function called by `generatePlot.m` to display a single PSTH or a level-stacked set. Supports optional Gaussian overlays and artifact shading.

## 📊 Data Requirements

Each script expects a `.mat` file with the following variables:
- `HistPeriod`: 5D PSTH array (rep × level × channel × trial × time)
- `details`: Metadata about the experiment (including stimulation levels and artifact duration)
- `PeriodEdges4Plotting`: Time bin edges used for plotting PSTHs

Make sure your data file (e.g., `VA_21_04_20-Trial017.mat`) is located in a `Data/` directory one level above the repository root.

## 🚀 Usage

1. Preprocess and fit Gaussians:
   ```matlab
   run('automatedGaussianFit.m')
