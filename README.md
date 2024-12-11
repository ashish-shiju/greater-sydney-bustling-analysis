# Greater Sydney Bustling Analysis 🌏

### Duration: Feb 2024 - June 2024
This project performs a geospatial analysis of Greater Sydney to evaluate the vibrancy and bustling nature of its regions. Using Python, SQL, and advanced data visualization tools, this project preprocesses data, performs geo-spatial computations, and generates interactive maps.

## 🎥 Demo

Here's a preview of the output `map_overlay_visualization.html` map:

![Map Analysis Visualization](./map_recording.gif)

## 📂 Project Structure

```plaintext
greater-sydney-bustling-analysis/
├── sql/                              
├── dataset/                          
├── bustling_analysis.ipynb        
├── map_overlay_visualization.html  
├── LICENSE                          
├── README.md                      
└── requirements.txt                  
```
## 🔧 Setup and Usage
### Prerequisites:

1. Install PostgreSQL and ensure it's running on your system.
2. Install Python (>= 3.8) and pip.
3. Ensure your database is configured to use PostGIS extensions.

### Create Credentials.json

Create a `Credentials.json` file in the root directory with the following structure:

```json
{
    "host": "your-database-host",
    "port": "your-database-port",
    "database": "your-database-name",
    "user": "your-database-username",
    "password": "your-database-password"
}
```



### Clone the Repository


```bash
git clone https://github.com/ashish-shiju/greater-sydney-bustling-analysis.git
cd greater-sydney-bustling-analysis
```

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Set Up the Database
Run the SQL scripts in the `sql/` folder to set up the database schema and preprocess data.
```bash
psql -U <your-username> -d <your-database> -f sql/schema.sql
psql -U <your-username> -d <your-database> -f sql/queries.sql
```

### Execute the Analysis
Open the Jupyter Notebook `bustling_analysis.ipynb` and run all cells to perform the analysis.

### Visualize Results
Open `map_overlay_visualization.html` in your browser to view the interactive map.

## 🔍 How It Works
### Database Connection:
A PostgreSQL database is used to store and process the data.
Connection details (host, port, database, user, password) are stored in a `Credentials.json` file, which must be created by the user.

### Data Preprocessing:
Raw datasets are cleaned and transformed using Python and SQL.
SQL scripts in the `sql/` folder define the database schema and queries for geospatial computations.

### Geo-Spatial Analysis:
Using Python libraries like GeoPandas and PostGIS, this project evaluates regional vibrancy.
GeoJSON files are used to overlay maps for spatial visualization.

### Interactive Visualization:
The results are presented through an interactive map generated with Folium.
The output is saved as `map_overlay_visualization.html`.


## 🧠 Features and Technology Used
### Python
Core programming language for data preprocessing, analysis, and visualization.

### GeoPandas and PostGIS
Perform geospatial computations and analysis.

### SQL
Manage and query structured data in the PostgreSQL database.

### Folium
Generate interactive map visualizations for clear insights.

## 🎯 Project Highlights
### Geo-Spatial Insights:
Analyze population density, transportation networks, and regional vibrancy.

### Dynamic Visualizations:
Explore interactive maps to derive actionable insights.

### Scalable Database:
Designed for scalability with PostgreSQL and PostGIS.


## ⚠️ Disclaimer
This project is for educational and analytical purposes only. Ensure all datasets and derived results are used responsibly.

## 📬 Contact
### For questions or collaboration:

Email: ashish.shiju@outlook.com

GitHub: [ashish-shiju](https://github.com/ashish-shiju)


