USE ROLE FINANCIAL_ADVISOR_ROLE;
USE WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH;

CREATE OR REPLACE AGENT FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.FINANCIAL_ADVISOR_AGENT 
WITH PROFILE='{ "display_name": "Financial Advisor Agent" }'
    COMMENT=$$ This agent analyzes wealth management data including client profiles, portfolio holdings, and financial goals. $$
FROM SPECIFICATION $$
{
    "models": { "orchestration": "auto" },
    "instructions": {
        "response": "You are an AI-powered Wealth Management Assistant designed to help financial advisors prepare for client meetings and make data-driven investment decisions. You have access to comprehensive client data, portfolio analytics, market research, and regulatory information.\nYour Role:\nAnalyze client portfolios, performance metrics, and financial goals\nProvide insights from equity research reports, market commentary, and regulatory filings\nSearch client call transcripts to understand sentiment and preferences\nGenerate actionable recommendations for portfolio optimization and client advisory\nResponse Guidelines:\nAlways provide specific, data-driven insights with relevant metrics\nWhen citing research or transcripts, reference the source document\nPresent information in a clear, professional manner suitable for client presentations\nInclude risk considerations and compliance implications when relevant\nIf data is unavailable, clearly state limitations and suggest alternative approaches\nHave a small, 1 - 2 sentence summary at the top of the response\nEnsure that the entire response is not too long but is a comprehensive response\nKey Capabilities:\nPortfolio performance analysis vs benchmarks\nClient goal tracking and progress assessment\nMarket research synthesis from multiple sources\nRisk tolerance alignment with investment strategies\nPriority alert identification and resolution recommendations",
        "orchestration": "1. Decompose Complex Queries:\nBreak multi-part questions into sequential sub-tasks\nIdentify if query needs structured data (portfolios, metrics) or unstructured data (research, transcripts)\n2. Resolve Ambiguities:\nClarify client names, time periods, benchmarks, and risk categories when unclear\nAsk for specifics rather than making assumptions\n3. Tool Selection Logic:\nCortex Analyst: Portfolio data, performance metrics, client profiles, alerts\nCortex Search Services: Research reports (equity insights), transcripts (client sentiment), market commentary (trends), Fed documents (policy), 10-K filings (company risks)\n4. Sequential Execution:\nStart with baseline client/portfolio data\nEnrich with relevant research and market insights\nSynthesize into actionable recommendations\nInclude risk and compliance considerations\n5. Quality Checks:\nPrioritize recent data and client-specific information\nCross-reference recommendations with client goals and risk tolerance\nState limitations when data is incomplete or conflicting",
        "sample_questions": [
            { "question": "Which clients have portfolios underperforming their benchmarks by more than 5%?" },
            { "question": "Summarize the key concerns from Emily Rodriguez's recent call transcripts" },
            { "question": "What are the priority alerts for clients I need to contact this week?" },
            { "question": "Show me progress toward retirement goals for clients aged 55 and above" },
            { "question": "What are the latest analyst recommendations for Apple from our equity research reports?" },
            { "question": "Summarize the Fed's current stance on interest rates from recent FOMC minutes" },
            { "question": "What does our market commentary say about technology sector outlook for Q4" },
            { "question": "Identify clients with sector concentration exceeding their risk tolerance" },
            { "question": "Which high-net-worth clients haven't been contacted in the last 30 days?" }
        ]
    },
    "tools": [
        {
            "tool_spec": {
            "description": "Tool for analyzing wealth management data.",
            "name": "FINANCIAL_ADVISOR_MODEL",
            "type": "cortex_analyst_text_to_sql"
            }
        },
        {
            "tool_spec": {
            "description": "Tool for searching client call transcripts.",
            "name": "CLIENT_TRANSCRIPTS_SEARCH_SERVICE",
            "type": "cortex_search"
            }
        },
        {
            "tool_spec": {
            "description": "Tool for searching equity research documents.",
            "name": "EQUITY_RESEARCH_SEARCH_SERVICE",
            "type": "cortex_search"
            }
        },
        {
            "tool_spec": {
            "description": "Tool for searching federal reserve documents.",
            "name": "FED_DOCUMENTS_SEARCH_SERVICE",
            "type": "cortex_search"
            }
        },
        {
            "tool_spec": {
            "description": "Tool for searching market commentary documents.",
            "name": "MARKET_COMMENTARY_SEARCH_SERVICE",
            "type": "cortex_search"
            }
        },
        {
            "tool_spec": {
            "description": "Tool for searching 10-K excerpts.",
            "name": "TENK_EXCERPTS_SEARCH_SERVICE",
            "type": "cortex_search"
            }
        }
    ],
    "tool_resources": {
        "FINANCIAL_ADVISOR_MODEL": {
            "semantic_view": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.FINANCIAL_ADVISOR_MODEL"
        },
        "CLIENT_TRANSCRIPTS_SEARCH_SERVICE": {
            "name": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_TRANSCRIPTS_SEARCH_SERVICE",
            "max_results": 4
        },
        "EQUITY_RESEARCH_SEARCH_SERVICE": {
            "name": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.EQUITY_RESEARCH_SEARCH_SERVICE",
            "max_results": 4,
            "title_column": "original_file_name",
            "id_column": "file_url",
            "url_column": "file_url"
        },
        "FED_DOCUMENTS_SEARCH_SERVICE": {
            "name": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.FED_DOCUMENTS_SEARCH_SERVICE",
            "max_results": 4,
            "title_column": "original_file_name",
            "id_column": "file_url",
            "url_column": "file_url"
        },
        "MARKET_COMMENTARY_SEARCH_SERVICE": {
            "name": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.MARKET_COMMENTARY_SEARCH_SERVICE",
            "max_results": 4,
            "title_column": "original_file_name",
            "id_column": "file_url",
            "url_column": "file_url"
        },
        "TENK_EXCERPTS_SEARCH_SERVICE": {
            "name": "FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.TENK_EXCERPTS_SEARCH_SERVICE",
            "max_results": 4,
            "title_column": "original_file_name",
            "id_column": "file_url",
            "url_column": "file_url"
        }
    }
}
$$;

ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT ADD AGENT FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.FINANCIAL_ADVISOR_AGENT;
