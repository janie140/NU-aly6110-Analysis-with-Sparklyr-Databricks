# NU-aly6110-Analysis-with-Sparklyr-Databricks
An analysis of electric vehicle adoption patterns and factors in Washington State

Introduce the real-world problem that can be solved with big data

The adoption of electric vehicles (EVs) is a critical step towards reducing greenhouse gas emissions and promoting sustainable transportation solutions. However, the widespread adoption of EVs presents several challenges, including infrastructure planning, consumer behavior analysis, and energy management. The "Electric Vehicle Population Data" provides a valuable opportunity to leverage big data techniques for addressing these challenges.

As the adoption of EVs increases, various stakeholders, including governments, urban planners, automakers, and energy providers, require insights into key aspects such as the geographic distribution of EVs, charging patterns, battery performance, etc. For example, efficient deployment of charging stations is crucial for the convenience and adoption of EVs. Big data analytics can help identify optimal locations for charging stations based on factors like EV adoption population, model preferences, and.... Furthermore, under other circumstances, understanding how users interact with EVs is vital for market expansion. Analyzing data on EV customer behaviors, charging times, and distances traveled can provide insights into user preferences, informing marketing strategies and future product developments.

We can utilize big data to stream, aggregate, analyze, and visualize the insights, in this case, publishing on the government website for all stakeholders and consumers to interact with.

The dataset selected, including a reason for selecting the data

Electric Vehicle Population Dataset is sourced from the official website of government data. “This dataset shows the Battery Electric Vehicles (BEVs) and Plug-in Hybrid Electric Vehicles (PHEVs) that are currently registered through Washington State Department of Licensing (DOL).”

Electric vehicle adoption in Washington State has already achieved remarkable heights, ranking among the top in the nation with approximately 17,140 registrations as of November 2021. Data from EVadoption.com reveals that the state accumulated an impressive 80,397 electric vehicles between 2011 and September 2021, positioning it as the fourth highest in the country. Also, “Washington has only recently joined California's Advanced Clean Cars II rules, aiming to make all new cars electric by 2030.” Washington State remains steadfastly committed to its journey towards a fully electric future for transportation. In summary, the dataset consists of 139K rows and 17 columns. Each row is a record of a registered vehicle.

The methodology used to analyze the data

In this big data analysis, the methodologies encompass data preprocessing, exploratory analysis, statistical analysis, and visualization. I utilized Sparklyr, R packages, and databricks cloud cluster processing.
