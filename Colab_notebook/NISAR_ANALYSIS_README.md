# SARC — NISAR S-Band SAR Unsupervised Analysis

**Project:** SARC — Satellite Analysis and Radar-based Characterization  
**Analysis:** Multi-temporal NISAR S-band SAR exploratory analysis  
**Study Area:** South Lhonak Lake region, Sikkim, India  
**Processing Environment:** Google Colab / Python  
**Status:** NISAR exploratory processing and unsupervised analysis completed

---

## 1. Project Overview

SARC is a research-driven satellite intelligence initiative focused on Synthetic Aperture Radar (SAR), Earth observation, environmental monitoring, and geospatial analysis.

This analysis uses three NISAR S-band Geocoded Covariance (GCOV) HDF5 products acquired in August and September 2026.

The objective is to investigate multi-temporal SAR backscatter behaviour, derive spatial and temporal features, identify exploratory feature groups using unsupervised machine learning, and locate statistically unusual SAR feature combinations.

The workflow combines:

- NISAR S-band GCOV observations
- HH and HV polarimetric channels
- Temporal backscatter and ratio analysis
- Feature engineering
- MiniBatch K-Means clustering
- Isolation Forest anomaly detection
- Spatial connected-component analysis
- Geospatial candidate inventory and map generation

**Scientific scope:** This is an exploratory SAR feature-analysis workflow. The results are not validated flood classifications, measured flood extents, or operational warnings.

---

## 2. Dataset Information

### 2.1 NISAR Dataset

| Parameter | Specification |
|---|---|
| Satellite mission | NISAR |
| Sensor frequency | S-band |
| Product type | GCOV |
| Product format | HDF5 |
| Polarizations | HH and HV |
| Acquisition mode | Ascending |
| Track | 170 |
| Frame | 15 |
| Look direction | Left-looking |
| Pixel spacing | 10 m |
| Projection | EPSG:32645 |
| Geocoded | Yes |
| Radiometric terrain correction | Applied |
| Noise correction | Not applied |
| Post-processing filtering | Not applied |
| Shadow masking | Not applied |
| RFI mitigation | FDNF |

### 2.2 Input Scene Inventory

Three NISAR S-band GCOV products were processed.

| No. | Acquisition date | Product |
|---|---|---|
| 1 | 24 August 2026 | `NISAR_S2_PR_GCOV_028_170_A_015_3700_DHNA_A_20260824T233024_233101_P00500_M_F_I_001.h5` |
| 2 | 05 September 2026 | `NISAR_S2_PR_GCOV_029_170_A_015_3700_DHNA_A_20260905T233024_233100_P00500_M_F_I_001.h5` |
| 3 | 29 September 2026 | `NISAR_S2_PR_GCOV_031_170_A_015_3700_DHNA_A_20260929T233024_233101_P00500_M_F_I_001.h5` |

The three scenes have a common acquisition configuration and compatible spatial grids for the analysis performed here.

**Original HDF5 file sizes:** Not recorded in the current processing inventory. They must be obtained from the original files rather than estimated.

### 2.3 HDF5 Data Structure

Primary data group:

`/science/SSAR/GCOV/grids/frequencyA`

Relevant datasets include:

| Dataset | Data type | Description |
|---|---|---|
| HHHH | float32 | HH Gamma0 covariance term |
| HVHV | float32 | HV Gamma0 covariance term |
| HHHV | complex64 | HH-HV cross-covariance |
| mask | uint8 | Product validity mask |
| inputDataExceptionMask | uint8 | Input exception mask |
| numberOfLooks | float32 | Number of looks |
| rtcGammaToSigmaFactor | float32 | Gamma0-to-Sigma0 conversion factor |

The HHHV dataset is complex-valued and is treated separately from ordinary backscatter intensity measurements.

### 2.4 AOI Extraction

The analysis uses a focused region around South Lhonak Lake.

| Parameter | Value |
|---|---:|
| North | 27.2025° N |
| South | 27.1575° N |
| West | 88.4897° E |
| East | 88.5403° E |
| Projected CRS | EPSG:32645 |
| Pixel spacing | 10 m |
| AOI rows | 508 |
| AOI columns | 512 |
| Total AOI pixels | 260,096 |

Original full raster dimensions:

- Rows: 33,408
- Columns: 34,488

Extracted AOI window:

- Rows: `[11498:12006]`
- Columns: `[25512:26024]`
- Shape: `508 × 512`

Approximate projected AOI bounds:

- Easting: 647,520–652,640 m
- Northing: 3,004,740–3,009,820 m

All three scenes use the same extracted AOI dimensions and spatial grid.

### 2.5 AOI Quality Checks

The following checks passed during processing:

- All three scenes were aligned to the same AOI window.
- All AOI pixels were finite for the processed feature inputs.
- Validity mask values in the AOI were 1.
- Input exception mask values in the AOI were 0.
- Number of looks was 16 throughout the AOI.
- All scenes used EPSG:32645.
- The extracted AOI contained 260,096 pixels per scene.

---

## 3. Backscatter Processing

The analysis used the HH and HV covariance terms from the GCOV products.

### 3.1 Gamma0 and Sigma0

The product provides Gamma0 measurements and a terrain-related conversion factor.

Sigma0 was derived using:

`Sigma0 = Gamma0 × rtcGammaToSigmaFactor`

Decibel conversion:

`Sigma0_dB = 10 × log10(Sigma0)`

Only positive valid intensity values are suitable for logarithmic conversion.

### 3.2 Derived SAR Features

The preprocessing stage generated 15 raster layers per scene.

| Feature | Description |
|---|---|
| Gamma0 HH | HH Gamma0 backscatter |
| Gamma0 HH dB | HH Gamma0 in decibels |
| Gamma0 HV | HV Gamma0 backscatter |
| Gamma0 HV dB | HV Gamma0 in decibels |
| HHHV Sigma0 Imag | Imaginary cross-covariance component |
| HHHV Sigma0 Real | Real cross-covariance component |
| HH_HV_Ratio | HH-to-HV ratio |
| HH_HV_Ratio_dB | HH-to-HV ratio in decibels |
| Normalized_CrossCov_Magnitude | Normalized cross-covariance magnitude |
| Normalized_CrossCov_Phase_rad | Normalized cross-covariance phase |
| ValidMask | Valid-pixel mask |
| Sigma0 HH | HH Sigma0 backscatter |
| Sigma0 HH dB | HH Sigma0 in decibels |
| Sigma0 HV | HV Sigma0 backscatter |
| Sigma0 HV dB | HV Sigma0 in decibels |

Total preprocessing output:

**3 scenes × 15 layers = 45 raster layers.**

---

## 4. Temporal Change Analysis

Three acquisition dates produce three unique scene-comparison pairs.

| Pair | Earlier date | Later date |
|---|---|---|
| 1 | 24 August 2026 | 05 September 2026 |
| 2 | 05 September 2026 | 29 September 2026 |
| 3 | 24 August 2026 | 29 September 2026 |

Temporal comparison was performed using three SAR metrics:

1. Sigma0 HH dB
2. Sigma0 HV dB
3. HH/HV Ratio dB

The workflow generated nine pairwise change rasters.

For a feature \(X\):

`Change = X(later acquisition) - X(earlier acquisition)`

These layers describe observed differences between acquisition dates. They do not independently establish the physical cause of a change.

### Temporal Change Outputs

Directory:

`processed/nisar/change_analysis/`

Map exports:

- `SARC_NISAR_Temporal_Change.png`
- `SARC_NISAR_Temporal_Change.pdf`

---

## 5. Temporal Statistics

Temporal statistics were calculated for three SAR metrics across the three acquisitions.

Metrics:

- Sigma0 HH dB
- Sigma0 HV dB
- HH/HV Ratio dB

Statistics:

- Mean
- Standard deviation
- Minimum
- Maximum
- Range
- Temporal trend in dB per day

Total:

**3 metrics × 6 statistics = 18 raster layers.**

The temporal trend uses the acquisition dates and their elapsed time intervals.

Acquisition intervals:

- 24 August to 05 September: 12 days
- 05 September to 29 September: 24 days

All three dates had 260,096 valid common AOI pixels.

Output directory:

`processed/nisar/temporal_statistics/`

---

## 6. Machine Learning Feature Engineering

### 6.1 Feature Stack

A total of 30 features were assembled for unsupervised analysis.

| Feature group | Number of features |
|---|---:|
| Date-specific SAR features | 9 |
| Temporal statistical features | 12 |
| Pairwise change features | 9 |
| **Total** | **30** |

#### Date-specific features

Three metrics were retained for each of the three acquisition dates:

- Sigma0 HH dB
- Sigma0 HV dB
- HH/HV Ratio dB

Total: 9 features.

#### Temporal statistical features

Four selected statistics were used for each metric:

- Mean
- Standard deviation
- Range
- Trend in dB per day

Total: 12 features.

#### Pairwise change features

Three metrics were compared across all three date pairs.

Total: 9 features.

### 6.2 Feature Matrix

| Parameter | Value |
|---|---:|
| Number of pixels | 260,096 |
| Number of features | 30 |
| Feature matrix shape | 260,096 × 30 |
| AOI raster shape | 508 × 512 |
| Valid pixel coverage | 100% |
| CRS | EPSG:32645 |

### 6.3 Feature Engineering Outputs

Directory:

`processed/nisar/ml_features/`

Files:

- `SARC_NISAR_ML_Feature_Stack.tif`
- `SARC_NISAR_ML_Feature_Matrix.npz`
- `feature_band_metadata.csv`

QA metadata:

- `metadata/nisar_ml_feature_source_QA.csv`
- `metadata/nisar_ml_feature_engineering_summary.json`

Integrated feature-engineering QA: **PASSED**

---

## 7. Unsupervised Machine Learning

Two unsupervised algorithms were applied to the 30-dimensional SAR feature matrix.

### 7.1 Feature Scaling

Algorithm:

`RobustScaler`

Purpose:

- Scale feature values.
- Reduce the influence of extreme values on scaling.
- Prepare the multi-feature dataset for clustering and anomaly detection.

### 7.2 MiniBatch K-Means

Configuration:

| Parameter | Value |
|---|---:|
| Algorithm | MiniBatchKMeans |
| Number of clusters | 4 |
| Random state | 42 |
| Batch size | 8,192 |
| Initializations | 10 |
| Maximum iterations | 200 |
| Inertia | 3,516,439.0 |

#### Cluster Distribution

| Cluster | Pixels | Percentage |
|---|---:|---:|
| Cluster 1 | 37,139 | 14.28% |
| Cluster 2 | 58,582 | 22.52% |
| Cluster 3 | 82,195 | 31.60% |
| Cluster 4 | 82,180 | 31.60% |
| **Total** | **260,096** | **100%** |

Cluster numbers are algorithmic identifiers. They do not represent predefined land-cover or flood-severity categories.

### 7.3 Isolation Forest

Configuration:

| Parameter | Value |
|---|---:|
| Algorithm | IsolationForest |
| Number of estimators | 100 |
| Contamination | 0.02 |
| Random state | 42 |
| Parallel jobs | -1 |

Results:

| Metric | Result |
|---|---:|
| Input pixels | 260,096 |
| Flagged anomaly pixels | 5,202 |
| Anomaly percentage | 2.00% |

The contamination parameter was analyst-selected. Therefore, the 2% anomaly fraction must not be interpreted as an observed environmental anomaly prevalence.

### 7.4 Machine Learning Outputs

Directory:

`processed/nisar/ml_results/`

Files:

- `SARC_NISAR_KMeans_Clusters.tif`
- `SARC_NISAR_IsolationForest_Anomalies.tif`
- `SARC_NISAR_Anomaly_Scores.tif`
- `SARC_NISAR_Cluster_Summary.csv`
- `SARC_NISAR_Anomaly_Summary.csv`
- `SARC_NISAR_Unsupervised_Models.joblib`

Integrated unsupervised-model QA: **PASSED**

---

## 8. Cluster Interpretation

Cluster-wise feature profiles were calculated to examine how the four algorithmic groups differ across the 30 input features.

Outputs:

- `SARC_Cluster_Feature_Profiles.csv`
- `SARC_Cluster_Feature_Separation.csv`
- `SARC_Anomaly_By_Cluster.csv`

Visualizations:

- `SARC_Cluster_Feature_Heatmap.png`
- `SARC_NISAR_Cluster_Map.png`
- `SARC_NISAR_Anomaly_Map.png`
- `SARC_Anomaly_Score_Distribution.png`

Summary:

`metadata/sarc_cluster_interpretation_summary.json`

### 8.1 Top Differentiating Features

The following features had the highest reported cluster mean-range separation.

| Rank | Feature | Separation |
|---:|---|---:|
| 1 | HH_HV_Ratio_dB_Change_20260824_20260929 | 13.078833 |
| 2 | HH_HV_Ratio_dB_Change_20260824_20260905 | 11.586453 |
| 3 | HH_HV_Ratio_dB_20260824 | 8.484995 |
| 4 | HH_HV_Ratio_dB_Change_20260905_20260929 | 7.631476 |
| 5 | Sigma0_HH_dB_Change_20260824_20260929 | 6.709139 |
| 6 | Sigma0_HV_dB_Change_20260824_20260929 | 6.369694 |
| 7 | Sigma0_HH_dB_20260824 | 6.142097 |
| 8 | HH_HV_Ratio_dB_20260905 | 5.916457 |
| 9 | Sigma0_HV_dB_Change_20260824_20260905 | 5.809290 |
| 10 | Sigma0_HH_dB_Change_20260824_20260905 | 5.777163 |

These values indicate feature separation within the fitted clustering result. They are not measures of flood-detection accuracy.

### 8.2 Anomaly Distribution by Cluster

| Cluster | Anomaly pixels | Anomaly percentage within cluster |
|---|---:|---:|
| Cluster 1 | 2,158 | 5.81% |
| Cluster 2 | 1,974 | 3.37% |
| Cluster 3 | 684 | 0.83% |
| Cluster 4 | 386 | 0.47% |

Clusters 1 and 2 contain 4,132 of the 5,202 flagged anomaly pixels, approximately 79.4% of all flagged pixels.

This indicates a disproportionate concentration of statistical anomalies in those two feature groups. It does not establish the physical nature of those anomalies.

---

## 9. Spatial Coherence Analysis

An 8-neighbour connected-component analysis was performed to investigate the spatial organization of cluster and anomaly pixels.

### 9.1 Cluster Spatial Coherence

| Cluster | Components | Largest component (pixels) | Pixels in components ≥10 pixels |
|---|---:|---:|---:|
| Cluster 1 | 12,294 | 166 | 31.46% |
| Cluster 2 | 10,639 | 1,343 | 61.25% |
| Cluster 3 | 8,994 | 523 | 77.50% |
| Cluster 4 | 7,358 | 9,568 | 81.51% |

### 9.2 Anomaly Spatial Coherence

| Metric | Result |
|---|---:|
| Anomaly pixels | 5,202 |
| Connected components | 3,049 |
| Largest component | 34 pixels |
| Median component size | 1 pixel |
| Components ≥10 pixels | 36 |
| Components ≥25 pixels | 3 |
| Anomaly pixels in components ≥10 pixels | 10.30% |
| Anomaly pixels in components ≥25 pixels | 1.85% |

At 10 m pixel spacing, one pixel represents a nominal grid area of 100 m².

This pixel-area conversion describes raster geometry only. It must not be interpreted as flood-affected area.

Output:

`processed/nisar/ml_results/SARC_Spatial_Coherence_Analysis.csv`

Integrated spatial-coherence QA: **PASSED**

---

## 10. Geospatial Anomaly Inventory

Connected anomaly components were inventoried to identify spatially coherent candidates for further inspection.

A minimum component threshold of 10 pixels was applied.

### 10.1 Inventory Results

| Metric | Result |
|---|---:|
| Total anomaly pixels | 5,202 |
| Total connected components | 3,049 |
| Components ≥10 pixels | 36 |
| Components included in candidate GeoJSON | 36 |

### 10.2 Largest Candidate Components

| Candidate | Pixels | Nominal raster area | Dominant cluster |
|---|---:|---:|---:|
| 1 | 34 | 0.34 ha | Cluster 1 |
| 2 | 32 | 0.32 ha | Cluster 2 |
| 3 | 30 | 0.30 ha | Cluster 1 |

Largest candidate centroid:

- Longitude: 88.508108° E
- Latitude: 27.171896° N

Second candidate centroid:

- Longitude: 88.513438° E
- Latitude: 27.169866° N

Third candidate centroid:

- Longitude: 88.507704° E
- Latitude: 27.165489° N

These are statistical anomaly candidates, not mapped flood polygons.

### 10.3 Geospatial Outputs

- `processed/nisar/ml_results/SARC_Anomaly_Component_Inventory.csv`
- `outputs/maps/nisar/ml_analysis/SARC_Anomaly_Candidates.geojson`

The GeoJSON contains the 36 components meeting the minimum 10-pixel threshold.

---

## 11. Final Research Map

The final three-panel research map combines:

**Panel A — Unsupervised SAR Clusters**

Displays the four K-Means feature groups across the AOI.

**Panel B — Isolation Forest Anomaly Flags**

Displays pixels flagged by the Isolation Forest model.

**Panel C — Connected Anomaly Candidates**

Displays connected anomaly components containing at least 10 pixels, coloured by component identifier.

Final exports:

- `outputs/maps/nisar/ml_analysis/SARC_NISAR_Final_Research_Map.png`
- `outputs/maps/nisar/ml_analysis/SARC_NISAR_Final_Research_Map.pdf`

Consolidated summary:

`metadata/SARC_NISAR_Final_Research_Summary.json`

---

## 12. Project Directory Structure

The following is the logical SARC project structure used by this workflow.

```text
SARC/
│
├── metadata/
│   ├── nisar_ml_feature_source_QA.csv
│   ├── nisar_ml_feature_engineering_summary.json
│   ├── sarc_cluster_interpretation_summary.json
│   ├── SARC_NISAR_Final_Research_Summary.json
│   └── sarc_runtime_checkpoint.json
│
├── processed/
│   └── nisar/
│       ├── preprocessed/
│       │   └── 45 preprocessed raster layers
│       │
│       ├── change_analysis/
│       │   └── 9 temporal change rasters
│       │
│       ├── temporal_statistics/
│       │   └── 18 temporal statistical rasters
│       │
│       ├── ml_features/
│       │   ├── SARC_NISAR_ML_Feature_Stack.tif
│       │   ├── SARC_NISAR_ML_Feature_Matrix.npz
│       │   └── feature_band_metadata.csv
│       │
│       └── ml_results/
│           ├── SARC_NISAR_KMeans_Clusters.tif
│           ├── SARC_NISAR_IsolationForest_Anomalies.tif
│           ├── SARC_NISAR_Anomaly_Scores.tif
│           ├── SARC_NISAR_Cluster_Summary.csv
│           ├── SARC_NISAR_Anomaly_Summary.csv
│           ├── SARC_NISAR_Unsupervised_Models.joblib
│           ├── SARC_Cluster_Feature_Profiles.csv
│           ├── SARC_Cluster_Feature_Separation.csv
│           ├── SARC_Anomaly_By_Cluster.csv
│           ├── SARC_Spatial_Coherence_Analysis.csv
│           └── SARC_Anomaly_Component_Inventory.csv
│
└── outputs/
    └── maps/
        └── nisar/
            └── ml_analysis/
                ├── SARC_NISAR_Temporal_Change.png
                ├── SARC_NISAR_Temporal_Change.pdf
                ├── SARC_Cluster_Feature_Heatmap.png
                ├── SARC_NISAR_Cluster_Map.png
                ├── SARC_NISAR_Anomaly_Map.png
                ├── SARC_Anomaly_Score_Distribution.png
                ├── SARC_Anomaly_Candidates.geojson
                ├── SARC_NISAR_Final_Research_Map.png
                └── SARC_NISAR_Final_Research_Map.pdf
```

This is a logical inventory of the generated workflow outputs, not a guarantee that every file is present in every local copy.

---

## 13. Scientific Interpretation and Limitations

The analysis identifies statistical patterns in multi-temporal NISAR S-band SAR observations.

The following limitations must accompany any research presentation or publication.

### 13.1 Acquisition Date Limitation

The three NISAR scenes were acquired on:

- 24 August 2026
- 05 September 2026
- 29 September 2026

The South Lhonak Lake GLOF occurred on 4 October 2023.

Therefore, these NISAR observations are from approximately three years after the event. They cannot be used as immediate pre-event or post-event observations of the 2023 GLOF.

### 13.2 Product Limitation

The input product is GCOV, not Single Look Complex (SLC).

The current workflow does not establish interferometric phase change, displacement, or deformation measurements.

### 13.3 Unsupervised Classification Limitation

K-Means clusters are exploratory feature groups.

They are not:

- Flood classes
- Water classifications
- Land-cover classifications
- Validated hazard zones

### 13.4 Anomaly Detection Limitation

Isolation Forest identifies statistically unusual feature combinations.

An anomaly may be associated with multiple possible factors, including surface characteristics, environmental variability, acquisition conditions, or other SAR-related effects.

Without independent reference observations, the physical cause cannot be established.

### 13.5 Spatial Candidate Limitation

Connected components are spatial groupings of anomaly pixels.

Their nominal raster area is not equivalent to measured inundation area or affected terrain.

### 13.6 Validation Limitation

The current NISAR-only branch does not provide independent ground-truth validation, flood classification accuracy, precision, recall, F1-score, or an operational warning threshold.

---

## 14. Reproducibility

The analysis was implemented in Google Colab using Python and a Google Drive project directory.

Project root:

`/content/drive/MyDrive/SARC`

Key input and output paths are documented in this README.

### Reproduction requirements

A reproduction environment should include compatible versions of:

- Python
- NumPy
- Pandas
- Rasterio
- HDF5 support through h5py
- Scikit-learn
- SciPy
- Matplotlib
- GeoPandas or compatible geospatial tooling where required
- Joblib

Exact package versions should be captured from the original Colab runtime before claiming bit-for-bit reproducibility. They are not recorded in the current analysis inventory.

### Reproduction sequence

1. Mount Google Drive and access the SARC project directory.
2. Load the three original NISAR GCOV HDF5 products.
3. Extract the common AOI window.
4. Process HH and HV backscatter and derived features.
5. Generate pairwise temporal change rasters.
6. Calculate temporal statistical layers.
7. Build the 30-band feature stack and feature matrix.
8. Fit RobustScaler and MiniBatch K-Means.
9. Fit Isolation Forest and export anomaly outputs.
10. Generate cluster profiles and separation statistics.
11. Perform 8-neighbour connected-component analysis.
12. Generate the geospatial anomaly inventory.
13. Export the final research map and consolidated summary.

The saved model and intermediate products should be retained to support reproducibility and further inspection.

---

## 15. Future Research Work

The current NISAR-only analysis is one branch of the larger SARC research initiative.

The next research stages are:

### A. Historical Event Analysis

Acquire and verify Sentinel-1 SAR acquisitions around the South Lhonak Lake GLOF of 4 October 2023.

The pre-event and post-event observations must be independently verified for:

- Acquisition date
- Orbit direction
- Relative orbit
- Polarization
- Imaging mode
- Spatial coverage
- Processing level
- Calibration and terrain correction

Sentinel-1 C-band and NISAR S-band observations must not be treated as interchangeable measurements.

### B. Terrain Analysis

Acquire and verify the appropriate CartoDEM product.

Potential derivatives:

- Elevation
- Slope
- Aspect
- Flow direction
- Flow accumulation
- Drainage and terrain context

### C. Meteorological Data Integration

Identify the exact INSAT-3DR/MOSDAC product and verify its variables, units, temporal coverage, and spatial resolution before incorporating it into the analytical pipeline.

### D. Independent Validation

Use suitable independent reference data to assess whether observed SAR patterns correspond to known surface or hydrological changes.

### E. Research-to-Application Integration

Prepare dashboard-ready geospatial outputs for further inspection by research and disaster-management teams.

Any eventual community-facing information or advisory must retain human review and must not be represented as an official warning unless issued through the appropriate authority.

---

## 16. Conclusion

The SARC NISAR S-band exploratory analysis successfully processed three GCOV acquisitions over a common 508 × 512 pixel AOI.

The workflow produced:

- 45 preprocessed raster layers
- 9 temporal change rasters
- 18 temporal statistical rasters
- 30 machine-learning features per pixel
- 4 unsupervised SAR feature clusters
- 5,202 Isolation Forest anomaly flags
- 3,049 connected anomaly components
- 36 spatial candidates containing at least 10 pixels
- A consolidated geospatial anomaly inventory
- A final three-panel research map

The resulting workflow establishes a reproducible exploratory foundation for studying multi-temporal SAR feature variability and statistically unusual spatial patterns.

**The current results are exploratory and require independent physical interpretation and validation. They do not establish a validated reconstruction of the 2023 South Lhonak Lake GLOF.**

---

**SARC — Satellite Analysis and Radar-based Characterization**  
*Multi-temporal SAR analysis | Geospatial intelligence | Environmental monitoring*
