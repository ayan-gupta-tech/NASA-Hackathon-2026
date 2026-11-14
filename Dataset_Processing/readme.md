# Sentinel-1 SAR Data Preprocessing Using ESA SNAP

## 📌 Overview
This project focuses on the preprocessing and visualization of **Sentinel-1 Synthetic Aperture Radar (SAR)** data using **ESA SNAP (Sentinel Application Platform)**. 

Sentinel-1 SAR imagery is widely used for Earth observation, terrain analysis, and surface monitoring regardless of weather or lighting conditions. This workflow demonstrates handling **Sentinel-1 IW GRDH** data, extracting radiometrically calibrated backscatter bands (`Sigma0_VV` and `Sigma0_VH`), and exporting GeoTIFF outputs over the Uttarakhand region in India.

---

## 🛠️ Software & Tools Used
* **[ESA SNAP 14](https://step.esa.int/main/download/snap-download/)** – Sentinel-1 SAR data processing, calibration, and visualization.
* **Sentinel-1 SAR** – C-band Synthetic Aperture Radar satellite imagery.
* **GeoTIFF** – Georeferenced raster data format for storing processed outputs.

---

## 🛰️ Dataset Information
| Parameter | Details |
| :--- | :--- |
| **Satellite** | Sentinel-1 |
| **Sensor** | C-band SAR |
| **Acquisition Mode** | Interferometric Wide Swath (IW) |
| **Product Type** | Ground Range Detected High Resolution (GRDH) |
| **Polarizations** | Dual-Pol (`VV` and `VH`) |
| **Study Area** | Uttarakhand, India |
| **Output Format** | GeoTIFF (`.tif`) |

---

## ⚙️ Processing Workflow
1. **Data Ingestion:** Import Sentinel-1 IW GRDH satellite products into ESA SNAP 14.
2. **Band Access:** Extract and inspect the dual-polarization bands (`VV` and `VH`).
3. **Backscatter Visualization:** Generate and visualize `Sigma0_VV` and `Sigma0_VH` backscatter intensity images.
4. **Format Export:** Export the processed raster layers into georeferenced **GeoTIFF** format for downstream GIS/remote sensing analysis.
5. **Spatial Inspection:** Analyze terrain and surface backscatter characteristics across the Uttarakhand study area.

---

## 📂 Repository Structure
```text
Sentinel-1-SAR-Preprocessing/
│
├── README.md
│
├── images/
│   └── ESA_SNAP_preprocessing.png    # SNAP workspace & backscatter preview
│
├── data/
│   └── processed_data.tif            # Exported GeoTIFF raster
│
└── outputs/
    ├── Sigma0_VV                     # Calibrated VV backscatter output
    └── Sigma0_VH                     # Calibrated VH backscatter output
