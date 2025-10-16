# Financial Advisor for Asset Management

This repo contains everything you need to get started with Snowflake Intelligence for wealth management and asset management. You will learn how Snowflake Intelligence leverages natural language to drive deep insights from both structured portfolio data and unstructured market research. This example demonstrates how financial advisors can use AI to analyze client portfolios, track performance against benchmarks, and access insights from equity research, market commentary, and regulatory filings.

## Repository Structure

```text
├── README.md                              # This file
├── LEGAL.md                              # Legal notice
├── LICENSE                               # License information
├── scripts/
│   ├── setup.sql                         # Database setup script
│   ├── configure_search_services.sql     # Search services configuration
│   ├── semantic_models/                  # Semantic model definitions
│   │   └── FINANCIAL_ADVISOR_MODEL.yaml
│   └── pdfs/                             # Financial research documents
│       ├── AAPL_10K_excerpts_2024.pdf
│       ├── MSFT_10K_excerpts_2024.pdf
│       ├── equity_research_*.pdf
│       ├── Fed_FOMC_Minutes_November_2024.pdf
│       └── market_commentary_Q4_2024.pdf
```

## 📋 Getting Started

***

### **Required Setup**

Building a Cortex Agent for Snowflake Intelligence involves four main steps: creating the necessary Snowflake objects, uploading your financial research documents, configuring search services, and finally, creating and configuring the agent itself in Snowsight.

***

### **1. Setting Up the Environment**

First, you'll need to create the database, schema, stages, tables, and all necessary Snowflake objects. This ensures a clean and organized environment for your financial advisor demo.

Run the SQL commands in `scripts/setup.sql` in a Snowflake Workspaces SQL file.

***

### **2. Uploading Financial Research Documents via Snowsight**

Once the stage is created, you can manually upload your PDF research documents directly through the Snowsight user interface.

1. **Navigate to your Stage in Snowsight:**

   * In the Snowsight left-hand navigation pane, go to **Catalog -> Database Explorer**.
   * Expand your database (`FINANCIAL_ADVISOR_DEMO_DB`).
   * Expand the schema (`ANALYTICS`).
   * Click on **Stages**.
   * Click on the `FINANCIAL_ADVISOR_STAGE` stage.

2. **Upload the Files:**

   * Download all the PDF files from `scripts/pdfs/` directory
   * Click the **+ Files** button in the top-right corner.
   * Click **Browse**
   * Select all downloaded PDF files (equity research reports, 10-K excerpts, Fed minutes, and market commentary) then select **Open**.
   * Click **Upload** to begin the upload. You will see a progress bar for each file, and they will appear in the stage's file list once complete.

***

### **3. Uploading the Semantic Model**

The semantic model defines the structure of your data and enables natural language queries through Cortex Analyst. You need to upload the semantic model YAML file to make it available to the agent.

1. **Navigate to the Semantic Models Stage in Snowsight:**

   * In the Snowsight left-hand navigation pane, go to **Catalog -> Database Explorer**.
   * Expand your database (`FINANCIAL_ADVISOR_DEMO_DB`).
   * Expand the schema (`ANALYTICS`).
   * Click on **Stages**.
   * Click on the `SEMANTIC_MODELS_STAGE` stage.

2. **Upload the Semantic Model File:**

   * Download the `FINANCIAL_ADVISOR_MODEL.yaml` file from the `scripts/semantic_models/` directory
   * Click the **+ Files** button in the top-right corner.
   * Click **Browse**
   * Select the `FINANCIAL_ADVISOR_MODEL.yaml` file then **Open**.
   * Click **Upload** to begin the upload. Once complete, the file will appear in the stage's file list.

***

### **4. Configuring Search Services**

With your research documents uploaded, you need to configure the Cortex Search Services that will enable the agent to search through unstructured content.

Run all SQL commands in `scripts/configure_search_services.sql` in a Snowflake Workspaces SQL file. This will create search services for:

* Client call transcripts
* Equity research reports
* Market commentary documents
* 10-K filing excerpts
* General financial documents

***

### **5. Creating the Cortex Agent**

With your data loaded, semantic model uploaded, and search services configured, you can now create the agent in the Snowflake UI and connect it to your semantic models and search services.

1. **Create the Agent:**

   * In Snowsight, go to **AI & ML**.
   * Select **Agents**.
   * Click the **+ Create Agent** button.

2. **Fill in the Agent Details:**

   * **Display name:** `FINANCIAL_ADVISOR_AGENT`
   * **Description:**

     ```text
     This advanced AI assistant combines structured portfolio analytics with comprehensive market research to help you deliver exceptional client service. Instantly analyze client performance, track goal progress, and access insights from equity research, market commentary, and client interactions.
     ```

3. **Add the Semantic Model as a Tool:**

   * In the agent creation wizard, go to the **Tools** tab.
   * For the "Cortex Analyst" section, click the **+ Add** button.
   * Select the **Semantic Model File** option.
   * Choose the following:
     * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
     * **Schema:** `ANALYTICS`
     * **Stage:** `SEMANTIC_MODELS_STAGE`
     * Select `FINANCIAL_ADVISOR_MODEL.yaml` from the list
     * **Name:** `FINANCIAL_ADVISOR_SEMANTIC_MODEL`
     * **Description:** Click "Generate with Cortex"
     * **Query Timeout:** 60 seconds
   * Click **Add**.

4. **Add Cortex Search Services:**

   * Still in the **Tools** tab, under "Cortex Search Services", click **+ Add**.
   * For each search service below, configure:

   **CLIENT_TRANSCRIPTS_SEARCH_SERVICE:**

   * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
   * **Schema:** `ANALYTICS`
   * From the dropdown select: `FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_TRANSCRIPTS_SEARCH_SERVICE`
   * **Name:** `CLIENT_TRANSCRIPTS_SEARCH_SERVICE`
   * **Description:** `Search Service for client transcripts`
   * Click **Add**

   **RESEARCH_SEARCH_SERVICE:**

   * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
   * **Schema:** `ANALYTICS`
   * From the dropdown select: `FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.RESEARCH_SEARCH_SERVICE`
   * **Name:** `RESEARCH_SEARCH_SERVICE`
   * **Description:** `Search Service for equity research reports`
   * Click **Add**

   **DOCUMENTS_SEARCH_SERVICE:**

   * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
   * **Schema:** `ANALYTICS`
   * From the dropdown select: `FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.DOCUMENTS_SEARCH_SERVICE`
   * **Name:** `DOCUMENTS_SEARCH_SERVICE`
   * **Description:** `Search Service for general financial documents`
   * Click **Add**

   **MARKET_COMMENTARY_SEARCH_SERVICE:**

   * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
   * **Schema:** `ANALYTICS`
   * From the dropdown select: `FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.MARKET_COMMENTARY_SEARCH_SERVICE`
   * **Name:** `MARKET_COMMENTARY_SEARCH_SERVICE`
   * **Description:** `Search Service for market commentary and analysis`
   * Click **Add**

   **TENK_EXCERPTS_SEARCH_SERVICE:**

   * **Database:** `FINANCIAL_ADVISOR_DEMO_DB`
   * **Schema:** `ANALYTICS`
   * From the dropdown select: `FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.TENK_EXCERPTS_SEARCH_SERVICE`
   * **Name:** `TENK_EXCERPTS_SEARCH_SERVICE`
   * **Description:** `Search Service for 10-K filing excerpts`
   * Click **Add**

5. **Configure Orchestration:**

   * Navigate to the **Orchestration** tab.

   * **Orchestration Instructions:** Copy and paste the following:

     ```text
     1. Decompose Complex Queries:
     Break multi-part questions into sequential sub-tasks
     Identify if query needs structured data (portfolios, metrics) or unstructured data (research, transcripts)

     2. Resolve Ambiguities:
     Clarify client names, time periods, benchmarks, and risk categories when unclear
     Ask for specifics rather than making assumptions

     3. Tool Selection Logic:
     Cortex Analyst: Portfolio data, performance metrics, client profiles, alerts
     Cortex Search Services: Research reports (equity insights), transcripts (client sentiment), market commentary (trends), Fed documents (policy), 10-K filings (company risks)

     4. Sequential Execution:
     Start with baseline client/portfolio data
     Enrich with relevant research and market insights
     Synthesize into actionable recommendations
     Include risk and compliance considerations

     5. Quality Checks:
     Prioritize recent data and client-specific information
     Cross-reference recommendations with client goals and risk tolerance
     State limitations when data is incomplete or conflicting
     ```

   * **Response Instructions:** Copy and paste the following:

     ```text
     You are an AI-powered Wealth Management Assistant designed to help financial advisors prepare for client meetings and make data-driven investment decisions. You have access to comprehensive client data, portfolio analytics, market research, and regulatory information.

     Your Role:
     Analyze client portfolios, performance metrics, and financial goals
     Provide insights from equity research reports, market commentary, and regulatory filings
     Search client call transcripts to understand sentiment and preferences
     Generate actionable recommendations for portfolio optimization and client advisory

     Response Guidelines:
     Always provide specific, data-driven insights with relevant metrics
     When citing research or transcripts, reference the source document
     Present information in a clear, professional manner suitable for client presentations
     Include risk considerations and compliance implications when relevant
     If data is unavailable, clearly state limitations and suggest alternative approaches
     Have a small, 1 - 2 sentence summary at the top of the response
     Ensure that the entire response is not too long but is a comprehensive response

     Key Capabilities:
     Portfolio performance analysis vs benchmarks
     Client goal tracking and progress assessment
     Market research synthesis from multiple sources
     Risk tolerance alignment with investment strategies
     Priority alert identification and resolution recommendations
     ```

6. **Finalize and Create:**

   * Review the agent's details, tools, and orchestration settings.
   * Click **Save**.

***

### **Using Your Agent**

1. **Navigate to Snowflake Intelligence:**
   * In Snowsight, go to **AI & ML**.
   * Select **Snowflake Intelligence**.

2. **Select Your Agent:**
   * Choose `FINANCIAL_ADVISOR_AGENT` from the agent dropdown.

3. **Try the Example Prompts:**
   * Copy and paste any of the example prompts above to explore the agent's capabilities.
   * Experiment with your own questions combining portfolio analytics, market research, and client insights.

Your new Cortex Agent is now configured and ready to be used in the Snowflake Intelligence chat. You can now use the prompts from the demo to test its functionality.

***

### **Example Prompts for Snowflake Intelligence**

These are key prompts that can be used to explore Snowflake Intelligence for financial advisory, designed to be copy-pasted directly into the Snowflake Intelligence chat. They demonstrate the platform's ability to combine structured portfolio analytics with unstructured research insights.

1. **Which clients have portfolios underperforming their benchmarks by more than 5%?**
   * **Purpose:** This query demonstrates Snowflake Intelligence's ability to analyze structured portfolio performance data and identify clients that need attention.

2. **Summarize the key concerns from Emily Rodriguez's recent call transcripts**
   * **Purpose:** This highlights the platform's capability to search and synthesize unstructured data (client transcripts) to understand client sentiment and concerns.

3. **What are the priority alerts for clients I need to contact this week?**
   * **Purpose:** This illustrates the platform's ability to prioritize actionable items from structured alert data to help advisors manage their client relationships efficiently.

4. **Show me progress toward retirement goals for clients aged 55 and above**
   * **Purpose:** This demonstrates goal tracking capabilities combined with demographic filtering to help advisors monitor client progress toward specific financial objectives.

5. **What are the latest analyst recommendations for Apple from our equity research reports?**
   * **Purpose:** This showcases the platform's ability to search through unstructured research documents and extract specific investment recommendations.

6. **Summarize the Fed's current stance on interest rates from recent FOMC minutes**
   * **Purpose:** This illustrates how the platform can analyze regulatory documents and provide macroeconomic context for investment decisions.

7. **What does our market commentary say about technology sector outlook for Q4**
   * **Purpose:** This demonstrates sector-specific research synthesis to help advisors understand market trends and positioning.

8. **Identify clients with sector concentration exceeding their risk tolerance**
   * **Purpose:** This powerful prompt showcases **risk management analytics**, combining portfolio composition data with client risk profiles to identify potential issues.

9. **Which high-net-worth clients haven't been contacted in the last 30 days?**
   * **Purpose:** This demonstrates **relationship management** capabilities, helping advisors maintain regular contact with their most important clients.

***
