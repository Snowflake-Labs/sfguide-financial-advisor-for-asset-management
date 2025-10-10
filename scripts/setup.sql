USE ROLE ACCOUNTADMIN;
ALTER SESSION SET query_tag = '{"origin":"sf_sit-is","name":"financial_advisor_for_asset_management","version":{"major":1,"minor":0},"attributes":{"is_quickstart":1,"source":"sql"}}';

-- Create custom role for Retail Snowflake Intelligence
CREATE OR REPLACE ROLE FINANCIAL_ADVISOR_ROLE
    COMMENT = 'Role for Financial Advisor for Asset Management Demo';

-- Create warehouse
CREATE OR REPLACE WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH
  WITH 
  WAREHOUSE_SIZE = 'X-SMALL'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse for financial advisor demo';

-- Grant warehouse usage to custom role
GRANT USAGE ON WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT OPERATE ON WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH TO ROLE FINANCIAL_ADVISOR_ROLE;

USE WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH;

-- Create database
CREATE DATABASE IF NOT EXISTS FINANCIAL_ADVISOR_DEMO_DB;
USE DATABASE FINANCIAL_ADVISOR_DEMO_DB;

-- Create schema
CREATE OR REPLACE SCHEMA ANALYTICS;
USE SCHEMA ANALYTICS;

-- Grant create privileges on schemas
GRANT CREATE TABLE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE VIEW ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE STAGE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE FILE FORMAT ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE FUNCTION ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE TABLE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE VIEW ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE STAGE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE FILE FORMAT ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE FUNCTION ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT CREATE SEMANTIC VIEW ON SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;

-- Grant CORTEX_USER role for Cortex functions access
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE FINANCIAL_ADVISOR_ROLE;

-- role hierarchy
GRANT ROLE FINANCIAL_ADVISOR_ROLE TO ROLE sysadmin;

-- Create stages for data and audio files
CREATE OR REPLACE STAGE FINANCIAL_ADVISOR_DEMO_DB.analytics.FINANCIAL_ADVISOR_STAGE
    DIRECTORY = (ENABLE = TRUE)
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
    COMMENT = 'Stage for PDFs and semantic models';

-- Grant stage access to custom role
GRANT READ ON STAGE FINANCIAL_ADVISOR_DEMO_DB.analytics.FINANCIAL_ADVISOR_STAGE TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT WRITE ON STAGE FINANCIAL_ADVISOR_DEMO_DB.analytics.FINANCIAL_ADVISOR_STAGE TO ROLE FINANCIAL_ADVISOR_ROLE;

GRANT READ ON STAGE FINANCIAL_ADVISOR_DEMO_DB.analytics.FINANCIAL_ADVISOR_STAGE TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT WRITE ON STAGE FINANCIAL_ADVISOR_DEMO_DB.analytics.FINANCIAL_ADVISOR_STAGE TO ROLE FINANCIAL_ADVISOR_ROLE;

-- Grant SELECT privileges on all tables for Cortex Analyst semantic models
GRANT SELECT ON ALL TABLES IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;

-- Grant SELECT privileges on all views for Cortex Analyst semantic models
GRANT SELECT ON ALL VIEWS IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.public TO ROLE FINANCIAL_ADVISOR_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA FINANCIAL_ADVISOR_DEMO_DB.analytics TO ROLE FINANCIAL_ADVISOR_ROLE;

-- snowflake intelligence setup
CREATE DATABASE IF NOT EXISTS snowflake_intelligence;
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE PUBLIC;

CREATE SCHEMA IF NOT EXISTS snowflake_intelligence.agents;
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

GRANT CREATE AGENT ON SCHEMA snowflake_intelligence.agents TO ROLE FINANCIAL_ADVISOR_ROLE;

/*--
 Financial Advisor for Asset Management - Idempotent Setup Script
 This script creates all tables, views, dynamic tables, and stored procedures
 for the.
 
 Prerequisites: setup.sql should be run first to create the necessary roles,
 warehouse, database, and permissions.
--*/

-- Create table statements for Financial Advisor for Asset Management Demo Database
-- These tables store advisor, client, portfolio, and performance data

-- Advisor profile information
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.ADVISOR_PROFILE (
	ADVISOR_ID VARCHAR(16777216),
	ADVISOR_NAME VARCHAR(16777216),
	TITLE VARCHAR(16777216),
	YEARS_EXPERIENCE NUMBER(38,0),
	CLIENTS_MANAGED NUMBER(38,0),
	TOTAL_AUM NUMBER(38,0),
	SPECIALIZATION VARCHAR(16777216),
	BRANCH_LOCATION VARCHAR(16777216),
	LICENSE_TYPE VARCHAR(16777216),
	CONTACT_PHONE VARCHAR(16777216),
	CONTACT_EMAIL VARCHAR(16777216)
);

-- Client profile and demographic information
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_PROFILE (
	CLIENT_ID VARCHAR(16777216),
	CLIENT_NAME VARCHAR(16777216),
	AGE NUMBER(38,0),
	RISK_TOLERANCE VARCHAR(16777216),
	INVESTMENT_HORIZON_YEARS NUMBER(38,0),
	TOTAL_PORTFOLIO_VALUE NUMBER(38,0),
	CASH_BALANCE NUMBER(38,0),
	INVESTMENT_GOALS VARCHAR(16777216),
	LAST_REVIEW_DATE DATE,
	ADVISOR_ID VARCHAR(16777216),
	CLIENT_SINCE DATE
);

-- Portfolio holdings and asset allocations
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.PORTFOLIO_HOLDINGS (
	CLIENT_ID VARCHAR(16777216),
	ASSET_SYMBOL VARCHAR(16777216),
	ASSET_NAME VARCHAR(16777216),
	ASSET_CLASS VARCHAR(16777216),
	SECTOR VARCHAR(16777216),
	SHARES_HELD NUMBER(38,0),
	AVG_COST_BASIS NUMBER(38,2),
	CURRENT_PRICE NUMBER(38,2),
	MARKET_VALUE NUMBER(38,0),
	ALLOCATION_PERCENTAGE NUMBER(38,1),
	PURCHASE_DATE DATE,
	LAST_UPDATED DATE
);

-- Portfolio performance metrics and benchmarking
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.PERFORMANCE_METRICS (
	CLIENT_ID VARCHAR(16777216),
	PERIOD_END_DATE DATE,
	PORTFOLIO_VALUE NUMBER(38,0),
	PORTFOLIO_RETURN_MTD NUMBER(38,1),
	PORTFOLIO_RETURN_YTD NUMBER(38,1),
	PORTFOLIO_RETURN_1YR NUMBER(38,1),
	SP500_RETURN_MTD NUMBER(38,1),
	SP500_RETURN_YTD NUMBER(38,1),
	SP500_RETURN_1YR NUMBER(38,1),
	BENCHMARK_ALPHA NUMBER(38,1),
	SHARPE_RATIO NUMBER(38,2),
	MAX_DRAWDOWN NUMBER(38,1),
	VOLATILITY NUMBER(38,1)
);

-- Client financial goals and preferences
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_GOALS_PREFERENCES (
	CLIENT_ID VARCHAR(16777216),
	GOAL_ID VARCHAR(16777216),
	GOAL_TYPE VARCHAR(16777216),
	GOAL_DESCRIPTION VARCHAR(16777216),
	TARGET_VALUE NUMBER(38,0),
	TARGET_DATE DATE,
	PRIORITY VARCHAR(16777216),
	CURRENT_PROGRESS NUMBER(38,1),
	RISK_TOLERANCE_GOAL VARCHAR(16777216),
	NOTES VARCHAR(16777216)
);

-- Priority alerts for client portfolio management
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_PRIORITY_ALERTS (
	ADVISOR_ID VARCHAR(16777216),
	CLIENT_ID VARCHAR(16777216),
	ALERT_TYPE VARCHAR(16777216),
	PRIORITY_LEVEL VARCHAR(16777216),
	ALERT_DESCRIPTION VARCHAR(16777216),
	DAYS_SINCE_ALERT NUMBER(38,0),
	RECOMMENDED_ACTION VARCHAR(16777216),
	ESTIMATED_TIME_TO_RESOLVE NUMBER(38,0),
	LAST_CONTACT_DATE DATE
);

-- Unstructured call transcripts between advisors and clients
CREATE OR REPLACE TABLE FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_CALL_TRANSCRIPTS_UNSTRUCTURED (
	CLIENT_ID VARCHAR(16777216),
	CALL_DATE DATE,
	CALL_DURATION NUMBER(38,0),
	TRANSCRIPT_TEXT VARCHAR(16777216),
	CALL_DATE_VARCHAR VARCHAR(16777216)
);

-- Insert advisor profile record for Michael Thompson, a Senior Wealth Manager with 12 years of experience
-- This record includes professional details, contact information, and portfolio statistics
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.ADVISOR_PROFILE 
(ADVISOR_ID, ADVISOR_NAME, TITLE, YEARS_EXPERIENCE, CLIENTS_MANAGED, TOTAL_AUM, SPECIALIZATION, BRANCH_LOCATION, LICENSE_TYPE, CONTACT_PHONE, CONTACT_EMAIL)
VALUES 
('ADV001', 'Michael Thompson', 'Senior Wealth Manager', 12, 8, 18500000, 'High Net Worth Individuals', 'Manhattan - Park Avenue', 'Series 7/66', '(212) 555-0123', 'michael.thompson@bank.com');

-- Insert client call transcripts for various advisory calls between Michael Thompson and his clients
-- Each record contains the full conversation transcript, call metadata (date, duration), and client identifier
-- These transcripts capture detailed discussions about portfolio performance, investment strategy, and client goals
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_CALL_TRANSCRIPTS_UNSTRUCTURED 
(CLIENT_ID, CALL_DATE, CALL_DURATION, TRANSCRIPT_TEXT, CALL_DATE_VARCHAR)
VALUES 
('C003', '2024-11-05', 35, 'Michael Thompson: Good morning Robert, thanks for taking time to speak with me today. I wanted to discuss your portfolio performance and some concerns I have about the current allocation. How are you feeling about the markets lately?
Robert Williams: Hi Michael, good to speak with you. To be honest, I''m feeling a bit anxious. I''ve been watching the news about the election and all the geopolitical tensions, and it seems like my portfolio isn''t keeping pace with what I''m hearing from friends. I know I''m supposed to be conservative, but when I see the S&P up over 20% this year and my account barely moved, I start to wonder if we''re being too cautious.
Michael Thompson: I completely understand your concern, Robert. Let me walk through the numbers with you. Your portfolio is up about 4.2% year-to-date, which while not matching the S&P 500, is actually performing well within the parameters we established for your conservative risk profile. Remember, we have you allocated at about 40% equities and 50% bonds, with the remainder in cash. This is designed to preserve capital and provide steady income as you''re now in retirement.
Robert Williams: Right, but Michael, I keep thinking - what if we''re missing out on this rally? My neighbor Jim has been telling me about his tech stocks, and he''s up 30% this year. I understand the need for conservative investing, but at my age, shouldn''t I be taking advantage of strong markets when they happen?
Michael Thompson: That''s a great question, Robert. First, let me remind you that Jim''s concentrated tech holdings also come with significantly higher volatility. During the 2022 correction, those same positions likely lost 25-30% or more. Your portfolio, meanwhile, held up much better during that period. That said, I do think we have room to optimize. I''ve been analyzing your holdings, and I notice we''re quite heavy in some older bond positions that aren''t yielding what they should in today''s environment.
Robert Williams: What do you mean exactly? Are we holding bonds that are underperforming?
Michael Thompson: Exactly. For instance, we have a significant position in some Treasury bonds we purchased when rates were much lower. With rates where they are today, we could potentially harvest some tax losses there and redeploy into higher-yielding instruments. I''m also thinking we could incrementally increase your equity allocation from 40% to perhaps 45% - still conservative, but giving you a bit more upside participation.
Robert Williams: That sounds more reasonable. What kind of timeline are we looking at for making these changes? And what impact do you think this could have on my income stream? The dividend income is important for our monthly expenses.
Michael Thompson: Great questions. I''d propose we implement these changes over the next 4-6 weeks to avoid any market timing issues. Regarding income, the changes I''m suggesting should actually increase your dividend yield slightly. We''d be moving into some higher-yielding dividend aristocrats - companies that have increased dividends for 25+ consecutive years. Think companies like Johnson & Johnson, Procter & Gamble, and some utilities. These provide the stability you need but with better income generation than our current mix.
Robert Williams: I like the sound of that. Johnson & Johnson we already have, right? I remember you mentioning them before. And Procter & Gamble - that''s solid, everyday products people need regardless of the economy.
Michael Thompson: Exactly right, Robert. You already own J&J, and it''s been a good performer for us. P&G is another example of what I''d call ''boring but beautiful'' - consistent, predictable cash flows with steady dividend growth. These aren''t going to double in a year, but they''re also not going to keep you awake at night worrying about volatility.
Robert Williams: This all makes sense. I suppose I was getting caught up in FOMO - fear of missing out, as my granddaughter calls it. You know, Michael, I really appreciate that you''re not just pushing me into riskier investments to chase returns. I remember in 2008 when our previous advisor had us in all sorts of complex products that we didn''t understand.
Michael Thompson: That''s exactly why we keep your situation straightforward, Robert. Complexity doesn''t equal better returns - it usually just equals higher fees and more things that can go wrong. Your goals haven''t changed: preserve your nest egg, generate income for living expenses, and leave something for your children. We just want to optimize within those parameters.
Robert Williams: Sounds perfect. When should we schedule a follow-up call to review the changes?
Michael Thompson: Let me prepare a detailed rebalancing proposal and send it over by email tomorrow. We can then schedule a follow-up in about two weeks to review the changes and see how everything is settling in. Does that work for your schedule?
Robert Williams: That works great, Michael. Thanks for taking the time to explain everything clearly. I feel much better about our direction now.
Michael Thompson: My pleasure, Robert. Talk to you soon.', '2024-11-05'),
('C002', '2024-10-22', 42, 'Michael Thompson: Hi Sarah, thanks for making time today. I wanted to discuss your portfolio because I have some concerns about the concentration risk we''re currently carrying, particularly in the technology sector.
Sarah Chen: Hi Michael, of course. You mentioned concentration risk in your email - I assume you''re talking about my tech holdings? I''ve been pretty happy with the performance this year, to be honest.
Michael Thompson: You should be happy with the performance - you''re up 18.5% year-to-date, which is excellent. However, when I look at your allocation, you''re currently at about 65% technology exposure across various positions. That''s well above what we typically recommend for any single sector, even for aggressive investors like yourself.
Sarah Chen: I see what you''re saying, but Michael, tech is where the growth is. AI, cloud computing, autonomous vehicles - these are the trends shaping the future. Wouldn''t reducing my tech exposure mean missing out on the biggest opportunities?
Michael Thompson: I absolutely agree that technology will continue to drive long-term growth, Sarah. The question isn''t whether tech is a good investment - it''s whether having 65% of your portfolio in one sector is optimal from a risk management perspective. Let me give you a specific example: in 2022, the NASDAQ fell about 33% while other sectors like energy and utilities actually had positive returns. If we''d had a more diversified approach, we could have captured tech upside while having some protection during the downturns.
Sarah Chen: That makes sense in theory, but look at this year - tech has massively outperformed everything else. If I had been diversified into energy or utilities, wouldn''t I have given up significant returns?
Michael Thompson: Great point, and you''re absolutely right about this year. But here''s what I want you to consider: you''re 38 years old with a 25-year investment horizon. Over that time frame, we''re going to see multiple market cycles. Some years tech will lead, other years it will lag. The goal isn''t to maximize returns in any single year - it''s to build wealth consistently over decades while managing the risk of major drawdowns that could derail your long-term goals.
Sarah Chen: I understand the diversification argument, but what specific changes are you recommending? I don''t want to sell my winners just for the sake of rebalancing.
Michael Thompson: I''m not suggesting we sell your core winners like Microsoft or Apple. Instead, I''m thinking we could trim some positions and redeploy those proceeds into sectors that are currently undervalued but have strong long-term prospects. For example, healthcare is trading at attractive valuations right now, and with an aging population, it''s a secular growth story. We could also look at financials, which should benefit if interest rates remain elevated.
Sarah Chen: Healthcare is interesting. I work in the tech side of healthcare, so I see the innovation happening there. What specific areas would you be targeting?
Michael Thompson: I''d focus on a few key areas: pharmaceutical companies with strong pipelines - we already have some J&J exposure in other client portfolios and like their immunology franchise. Medical device companies are also compelling, especially those involved in robotic surgery and AI-assisted diagnostics. And then there''s the biotech space, though that''s obviously higher risk and we''d want to be selective there.
Sarah Chen: What about international diversification? I realize almost everything I own is U.S.-based.
Michael Thompson: Excellent observation, Sarah. You''re currently at about 95% U.S. exposure, which is another concentration risk. International markets, particularly emerging markets, are trading at significant discounts to U.S. valuations. Countries like India and some Southeast Asian markets are showing strong growth in technology adoption and digital transformation - areas that align with your interests and expertise.
Sarah Chen: That''s intriguing. I''ve been reading about India''s digital infrastructure buildout and their UPI payment system. From a tech perspective, they''re leapfrogging a lot of traditional systems.
Michael Thompson: Exactly! And you have the professional background to understand these trends better than most investors. We could allocate maybe 10-15% to international developed markets and another 5-10% to emerging markets, focusing on tech-forward countries and companies.
Sarah Chen: Okay, so if I''m understanding correctly, you''re suggesting we trim some of my U.S. tech positions - not eliminate them, just reduce the concentration - and redeploy into healthcare, financials, and international markets. What would this do to my expected returns?
Michael Thompson: Based on historical data and our modeling, this approach might reduce your returns in a year like 2024 where tech dominates, but it should actually increase your long-term risk-adjusted returns. You''d still have substantial tech exposure - maybe 40-45% instead of 65% - but with better diversification providing protection during tech selloffs and exposure to other growth opportunities.
Sarah Chen: I can see the logic. My one concern is timing - are we selling tech near the top? I know you always say you can''t time the market, but it does feel like AI is still in early innings.
Michael Thompson: You''re right that AI is still early, but here''s the thing - we''re not exiting tech completely. We''re just right-sizing it within your portfolio. And rather than trying to time when tech peaks, we''re positioning for whatever comes next. Some of that will be continued tech growth, but some might be in healthcare AI, financial services automation, or international tech adoption.
Sarah Chen: That makes a lot of sense. I like that we''re not abandoning the themes I believe in, just broadening our exposure to them. What''s the next step?
Michael Thompson: I''ll put together a specific rebalancing proposal showing exactly which positions we''d trim, where we''d redeploy the proceeds, and what the new allocation would look like. I''ll also model out some different scenarios so you can see the risk-return tradeoffs. Can we schedule a follow-up call next week to review the details?
Sarah Chen: Perfect. I appreciate you looking out for my long-term interests even when it means potentially reducing short-term returns. That''s exactly why I work with an advisor.
Michael Thompson: That''s what I''m here for, Sarah. We''ll get this positioned for long-term success while still capturing the growth opportunities you''re excited about.', '2024-10-22'),
('C005', '2024-11-12', 28, 'Michael Thompson: Good afternoon David, thanks for taking my call. I wanted to discuss the cash position in your account and get your thoughts on how we should deploy that capital.
David Kim: Hi Michael, good to hear from you. Yes, I''ve been wondering about that myself. I know we''ve been building up cash over the past few months, but with everything earning so little in the money market, I''ve been thinking we should put it to work somewhere.
Michael Thompson: Exactly what I wanted to talk about. You''re currently sitting at about 10% cash, which is higher than our target allocation of 5-7% for your risk profile. That represents roughly $410,000 that''s earning around 4.5% in money market funds when we could potentially be earning more in appropriate investments.
David Kim: Right, but Michael, I have to admit I''m feeling a bit nervous about deploying that cash right now. The markets feel expensive to me, and with my retirement coming up in five years, I don''t want to put that money at risk right before I need it.
Michael Thompson: I completely understand that concern, David. Let me share some thoughts on how we can deploy this capital while still maintaining the conservative approach that''s appropriate for your timeline. First, not all of this cash needs to go into stocks. We could look at some intermediate-term corporate bonds that are currently yielding 5-6%, which would give us both higher income and reasonable price stability.
David Kim: That''s interesting. What kind of corporate bonds are you thinking about? I want to make sure we''re not taking on too much credit risk.
Michael Thompson: I''m thinking investment-grade corporate bonds from companies we know well - think Microsoft, Johnson & Johnson, JPMorgan Chase. These are companies with fortress balance sheets that aren''t going anywhere, but their bonds are yielding significantly more than the Treasury alternatives. We could also look at some municipal bonds if you''re interested in tax-advantaged income.
David Kim: The tax-advantaged aspect is appealing, especially with my income where it is. But what about the equity side? You mentioned not putting all of this into stocks, but presumably some of it should go there?
Michael Thompson: Good question. For the equity portion, I''m thinking we could use a dollar-cost averaging approach over the next 3-4 months rather than investing everything at once. This way, if markets do pull back, we''ll benefit from lower average prices. And for the investments themselves, I''d focus on dividend-paying stocks - companies that provide income while you wait for potential capital appreciation.
David Kim: I like the dollar-cost averaging idea. That makes me feel more comfortable about the timing aspect. What kind of dividend yields are we talking about?
Michael Thompson: We could target a portfolio of dividend stocks yielding 3-4% on average, with a history of growing those dividends over time. Companies like Procter & Gamble, Coca-Cola, Walmart - these are businesses that have been paying and increasing dividends through multiple economic cycles. They''re not going to double in price, but they provide steady income and modest capital appreciation.
David Kim: Those are names I''m comfortable with. Boring but reliable, as you always say. What about the timeline for implementing this? I don''t want to rush, but I also don''t want to overthink it.
Michael Thompson: I''d suggest we start with the bond allocation first - maybe deploy half of the excess cash there over the next two weeks. Then we can begin the dollar-cost averaging approach for the equity portion, investing maybe $30,000-40,000 per month over the next three months. This gives us a measured approach that doesn''t require perfect timing.
David Kim: That sounds very reasonable. I like the phased approach. It lets me get comfortable with each step before moving to the next. What kind of impact should this have on my overall income from the portfolio?
Michael Thompson: Great question. Right now, your money market is generating about $18,000 annually on that $410,000. If we deploy into bonds yielding 5.5% and dividend stocks yielding 3.5% on average, we''re looking at potentially $20,000-22,000 in annual income from the same capital - that''s an extra $2,000-4,000 per year just from optimizing the allocation.
David Kim: That''s meaningful money, especially as we get closer to retirement. Every bit of additional income helps reduce the pressure on our other assets.
Michael Thompson: Exactly. And remember, many of these dividend-paying stocks have a history of increasing their dividends annually, so that income stream could grow over time even if you never add another dollar to the portfolio.
David Kim: I really like this plan, Michael. It addresses my concerns about market timing while still putting our cash to work more productively. When can we start implementing?
Michael Thompson: I can begin researching specific bond opportunities tomorrow and have some recommendations for you by the end of the week. For the equity portion, we could start that dollar-cost averaging program at the beginning of next month. Does that timeline work for you?
David Kim: Perfect. I appreciate you understanding my nervousness about the timing while still pushing me to optimize our returns. This feels like the right balance.
Michael Thompson: That''s exactly what we want, David - sleeping well while still making progress toward your goals. I''ll send you a detailed proposal by Friday and we can fine-tune it from there.', '2024-11-12'),
('C008', '2024-10-25', 38, 'Michael Thompson: Hi Maria, I wanted to check in with you about your portfolio performance and some concerns I have about the volatility we''ve been experiencing.
Maria Gonzalez: Hi Michael, thanks for calling. I have to say, this past month has been a bit of a roller coaster. I know you warned me that with my aggressive allocation I should expect volatility, but seeing the account swing $100,000 in a few weeks is still jarring.
Michael Thompson: I completely understand, Maria. Your portfolio is down about 12% over the past month, which is definitely more volatility than anyone likes to see. But before we discuss any changes, I want to put this in context - you''re still up 12.8% year-to-date, which is solid performance. The question is whether this level of volatility is something you''re comfortable with given your long-term goals.
Maria Gonzalez: That''s what I''m struggling with, Michael. In theory, I understand that I have a long time horizon - I''m only 33, so I have 30+ years until retirement. But in practice, watching these swings makes me question whether I can actually handle this level of risk. What if we have a major market crash and I panic and sell at the bottom?
Michael Thompson: That''s a very honest and important question, Maria. The fact that you''re questioning your risk tolerance during a volatile period actually shows good self-awareness. Many investors discover they''re not as risk-tolerant as they thought only after major losses. Let''s think through a few scenarios together.
Maria Gonzalez: Okay, I''m listening.
Michael Thompson: First, let''s look at what''s driving the volatility. You''re heavily concentrated in growth stocks - Tesla, NVIDIA, Meta - these are companies that can move 5-10% in a single day based on news or earnings. That concentration is amplifying your portfolio''s swings. We could reduce some of that concentration risk while still maintaining an aggressive growth orientation.
Maria Gonzalez: How would we do that? I don''t want to give up my growth potential, but maybe spreading the risk makes sense.
Michael Thompson: Great attitude. Instead of having large individual positions in Tesla and NVIDIA, we could trim those and add some diversified growth ETFs that give you exposure to hundreds of growth companies. You''d still get the upside when growth stocks perform, but any single company''s bad news wouldn''t impact you as much.
Maria Gonzalez: That makes sense. I''ve been reading about NVIDIA''s earnings coming up and realizing I''m probably too nervous about how one company''s results will affect my entire portfolio.
Michael Thompson: Exactly. And here''s another thought - we could add some sectors that historically perform well during different economic cycles. For instance, value stocks sometimes outperform growth stocks, and international stocks sometimes outperform domestic. By having exposure to these areas, we smooth out some of the volatility while still targeting long-term growth.
Maria Gonzalez: I''ve heard about value stocks but never really understood the difference. Can you explain?
Michael Thompson: Sure. Growth stocks like the ones you own are companies investors expect to grow rapidly - high revenues growth, expanding markets, new technologies. They tend to trade at high valuations because people are betting on future potential. Value stocks are more mature companies trading at lower valuations relative to their current earnings - think banks, utilities, consumer staples. They''re boring but often provide steady dividends and more stability.
Maria Gonzalez: So value stocks would be like the anchor in my portfolio? They wouldn''t necessarily grow as fast but they''d provide some stability during volatile periods?
Michael Thompson: That''s a perfect way to think about it, Maria. And the beautiful thing is that over long periods, having both growth and value exposure often provides better risk-adjusted returns than either alone. There are periods where value outperforms growth, and vice versa.
Maria Gonzalez: What about international stocks? I feel like I don''t know enough about foreign companies to be comfortable investing in them.
Michael Thompson: You don''t need to research individual foreign companies. We can use international ETFs that give you exposure to entire markets or regions. For instance, there are funds focused on developed markets like Europe and Japan, or emerging markets like India and Southeast Asia. These markets often move differently than the U.S., which can provide diversification benefits.
Maria Gonzalez: Okay, so the overall idea is to maintain my growth focus but spread the risk across more companies, sectors, and countries. What would this mean for my expected returns?
Michael Thompson: Based on historical data, this approach might slightly reduce your returns in years when U.S. growth stocks dominate - like this year - but should provide more consistent returns over time with lower volatility. You''d probably still average 8-10% annually over the long term, but with fewer of the stomach-churning months like we just experienced.
Maria Gonzalez: I think I''d prefer that trade-off. I want to be aggressive, but I also want to be able to stick with the plan during tough periods. If I panic and make emotional decisions, that''s going to hurt my long-term returns more than having a slightly more conservative allocation.
Michael Thompson: That''s exactly the right way to think about it, Maria. The best investment plan is the one you can stick with through market cycles. There''s no point having the most aggressive allocation on paper if you''re going to bail out during the first major drawdown.
Maria Gonzalez: So what''s the next step? I''m definitely interested in making some changes, but I don''t want to overreact to one bad month either.
Michael Thompson: I''ll put together a proposed new allocation that maintains your growth focus but with better diversification across companies, sectors, and geographies. We''ll model out the historical volatility so you can see how this approach would have performed during different market environments. Then we can implement the changes gradually over 4-6 weeks.
Maria Gonzalez: That sounds perfect. I feel better already just knowing we have a plan to address this. When should we follow up?
Michael Thompson: I''ll have the analysis ready by early next week. Let''s schedule a call for Monday to review the details and make sure you''re comfortable with the proposed changes before we start implementing.
Maria Gonzalez: Great, thanks Michael. I really appreciate you helping me think through this rationally instead of just telling me to tough it out.
Michael Thompson: Of course, Maria. Managing emotions is just as important as managing investments. We''ll get this right.', '2024-10-25'),
('C001', '2024-09-15', 31, 'Michael Thompson: Good morning John, thanks for making time for our quarterly review. I wanted to walk through your portfolio performance and discuss any changes to your goals or circumstances.
John Mitchell: Morning Michael, happy to catch up. Overall I''m feeling pretty good about things, though I''ve been wondering if we''re on track for my retirement goals given all the market uncertainty this year.
Michael Thompson: Great question to start with. Let me give you the numbers first, then we can talk about the trajectory toward your goals. Year-to-date, your portfolio is up 13.9%, which is solid performance though trailing the S&P 500''s 24.4% return. However, your risk-adjusted returns have been excellent - you''re achieving good gains with much lower volatility than the market.
John Mitchell: Right, I remember you explaining that we''re not trying to match the S&P but rather optimize for my specific situation. How does this performance translate to my retirement goal of $5 million by age 60?
Michael Thompson: Excellent question. At your current portfolio value of about $3.25 million and with 15 years until your target retirement age, you''re actually tracking slightly ahead of schedule. If we can maintain 7-8% average annual returns, which is reasonable given your allocation, you should reach that $5 million target with some cushion.
John Mitchell: That''s reassuring. What about the kids'' college fund? My oldest is 12 now, so we''ve got about 6 years before we need to start tapping that money.
Michael Thompson: The education goal is also on track. We''ve allocated about $800,000 for both children''s college expenses, and we''re currently at roughly $300,000 with that steady monthly contribution you''re making. As we get closer to needing the funds, we''ll want to gradually shift that portion to more conservative investments to protect against market volatility right when you need the money.
John Mitchell: Makes sense. I''ve been reading about college costs continuing to increase faster than inflation. Should we be increasing our target amount?
Michael Thompson: That''s smart thinking ahead. College inflation has been running about 5-6% annually versus 2-3% general inflation. I''d suggest we bump the target to $1 million to provide extra cushion, especially if you''re considering top-tier universities. That would mean increasing your monthly education savings by about $500.
John Mitchell: That''s manageable with my recent promotion. Speaking of which, I got a nice salary increase and bonus this year. What should I do with the extra cash?
Michael Thompson: Congratulations on the promotion! Let''s think about prioritizing that extra income. First, are you maxing out your 401k contribution? That''s still the best tax-advantaged growth vehicle you have.
John Mitchell: I''m contributing enough to get the full company match, but not maxing out the $23,000 limit.
Michael Thompson: I''d recommend we get you to the full $23,000 contribution first - that''s essentially free money in tax savings. After that, we could increase your taxable investment account contributions to accelerate progress toward your goals, or consider maximizing other tax-advantaged accounts like a backdoor Roth IRA.
John Mitchell: The Roth IRA sounds interesting. Can you explain how that would work with my income level?
Michael Thompson: Since your income is above the direct Roth IRA contribution limits, we''d do what''s called a ''backdoor Roth.'' You contribute $7,000 to a non-deductible traditional IRA, then immediately convert it to a Roth. It''s a bit more paperwork but gives you tax-free growth on that money forever. Over 15+ years, that could be very valuable.
John Mitchell: I like the idea of tax diversification. Right now most of my retirement savings are in traditional 401k accounts, so having some Roth money gives me flexibility in retirement.
Michael Thompson: Exactly right. In retirement, you can strategically withdraw from traditional accounts, Roth accounts, and taxable accounts to optimize your tax situation each year. It''s like having multiple tax buckets to draw from.
John Mitchell: What about my current portfolio allocation? Are there any adjustments you''d recommend?
Michael Thompson: Your current allocation is working well, but I have been thinking about a few tweaks. You''re currently about 60% stocks, 30% bonds, 10% cash. I''m wondering if we should consider adding some international exposure - maybe 10-15% of your equity allocation. International markets are trading at attractive valuations right now.
John Mitchell: I''ve always been hesitant about international investing. How do I evaluate companies I don''t know in countries I don''t understand?
Michael Thompson: You don''t need to pick individual foreign companies. We''d use low-cost international index funds that give you exposure to hundreds of companies across developed and emerging markets. The goal isn''t to outperform but to provide diversification. Sometimes international markets zig when U.S. markets zag.
John Mitchell: That makes sense from a diversification standpoint. What percentage would you suggest?
Michael Thompson: I''m thinking about 10% in developed international markets and 5% in emerging markets. This would come from reducing your U.S. stock allocation slightly, so your overall stock/bond/cash percentages stay the same.
John Mitchell: I''m comfortable with that. Anything else we should be considering?
Michael Thompson: One last item - estate planning. With your growing wealth and young children, we should make sure your will, beneficiaries, and insurance coverage are all up to date. Have you reviewed any of that recently?
John Mitchell: It''s been a few years. We did basic wills when the kids were born, but you''re right that our financial situation has changed significantly since then.
Michael Thompson: I''d recommend scheduling a meeting with an estate planning attorney in the next few months. With your net worth approaching $4 million including home and other assets, there are some planning strategies that could save your family significant taxes down the road.
John Mitchell: I''ll put that on my to-do list. Overall, Michael, I''m feeling good about where we stand. It''s reassuring to know we''re on track for our major goals.
Michael Thompson: You should feel good, John. You''re doing all the right things - saving consistently, staying disciplined with your allocation, and thinking ahead about future needs. We''ll continue fine-tuning as circumstances change, but you''re in excellent shape.
John Mitchell: Thanks for the comprehensive review. When should we check in next?
Michael Thompson: Let''s plan on another formal review in three months, but don''t hesitate to call if anything comes up before then. I''ll also send you a summary of today''s discussion and the proposed allocation changes for your review.
John Mitchell: Perfect, thanks Michael.', '2024-09-15'),
('C006', '2024-10-30', 25, 'Michael Thompson: Hi Lisa, thanks for taking my call. I wanted to check in on your portfolio and discuss the education funding goal for your twins.
Lisa Thompson: Hi Michael, good to hear from you. I''ve been meaning to call actually - I''ve been looking at some college cost projections online and I''m getting a bit worried about whether we''re saving enough.
Michael Thompson: That''s exactly what I wanted to discuss. I''ve been running some updated projections based on current college cost inflation rates, and I think we need to have a conversation about adjusting our savings rate for the twins'' education fund.
Lisa Thompson: I was afraid of that. What are the numbers looking like?
Michael Thompson: Well, the good news is that we''re not drastically behind. Your current education savings are at about $185,000 for the $600,000 goal we set. The challenge is that college costs have been inflating at 5-6% annually, which is well above general inflation. For twins born in 2006, we''re looking at college starting in 2024, so we have about 11 years to prepare.
Lisa Thompson: Wait, I think there''s a mistake - my twins were born in 2006, which makes them 18 now. They''re actually starting college next fall, not in 11 years.
Michael Thompson: Oh my goodness, you''re absolutely right - I was looking at the wrong data. If they''re starting college next fall, we need to have a very different conversation. With $185,000 saved for college costs that could run $400,000-500,000 for both children, we have a significant shortfall to address.
Lisa Thompson: That''s what I was worried about. I know we''ve been saving consistently, but the costs just keep going up. What are our options at this point?
Michael Thompson: Let''s think through this strategically, Lisa. First, we need to determine realistic college costs based on where your twins are actually planning to attend. Are they looking at in-state public schools, private universities, or a mix?
Lisa Thompson: They''re both pretty bright and are looking at some competitive schools. My daughter is interested in Northwestern for journalism, and my son is looking at engineering programs - maybe University of Illinois or Purdue. So we''re probably looking at a mix of private and public schools.
Michael Thompson: Okay, so Northwestern would be in the $80,000+ per year range all-in, while the public engineering schools might be $30,000-40,000 per year for in-state tuition. That''s a wide range depending on final decisions and financial aid.
Lisa Thompson: Right, and we''re still waiting to hear about financial aid and merit scholarships. But I want to make sure we have options regardless of how that turns out.
Michael Thompson: Smart approach. Here are a few strategies we should consider: First, we could shift your education savings to more conservative investments since you''ll need the money starting next year. Second, we might want to explore a home equity line of credit as a backup funding source - you have significant equity in your home. Third, we should optimize the tax benefits of education funding.
Lisa Thompson: Tell me more about the tax benefits. I know there are education tax credits, but I haven''t really explored that.
Michael Thompson: There are several opportunities. The American Opportunity Credit can provide up to $2,500 per student per year in tax credits for qualified expenses. There are also education loan interest deductions if you end up needing to borrow. And if we''re strategic about which accounts we draw from, we can minimize the tax impact of the withdrawals.
Lisa Thompson: What about 529 plans? We have some money there, but not all of our education savings are in 529s.
Michael Thompson: Good point. Your 529 money comes out tax-free for qualified education expenses, which is great. For the funds in your regular investment account earmarked for education, we''ll want to harvest any tax losses where possible and prioritize using appreciated assets that qualify for favorable capital gains treatment.
Lisa Thompson: This is getting complex. What''s the bottom line - do we have enough, or do we need to plan on borrowing?
Michael Thompson: Based on your current savings and conservative projections, you''ll likely need to supplement with some borrowing or other funding sources. But that''s not necessarily a bad thing - education can be thought of as an investment, and there are favorable loan terms available for education financing. The key is being strategic about it.
Lisa Thompson: I suppose I''d rather have some education debt than not give the kids the opportunities they''ve earned. What do you recommend as the next steps?
Michael Thompson: First, let''s reposition the education money you have saved into more conservative investments - we can''t afford market volatility when you need the money next year. Second, let''s explore that home equity line of credit so you have it available if needed. Third, I''ll connect you with a college funding specialist who can help optimize the financial aid and tax strategies.
Lisa Thompson: That sounds like a good plan. I feel better having a clear strategy rather than just worrying about it. When can we start implementing these changes?
Michael Thompson: I can begin repositioning the investment accounts this week. For the home equity line, I''ll send you some lender recommendations - it''s better to set that up before you need it. And I''ll get you connected with the college funding specialist within the next few days.
Lisa Thompson: Perfect. I really appreciate you staying on top of this timeline. I can''t believe how fast these 18 years went by.
Michael Thompson: It does go quickly! But you''ve been diligent about saving, and we''ll make sure the twins have the funding they need for their education goals.', '2024-10-30'),
('C007', '2024-11-08', 33, 'Michael Thompson: Good morning James, thanks for taking time to speak with me today. I wanted to discuss your portfolio''s income generation and see how well it''s meeting your retirement needs.
James Anderson: Good morning Michael. Actually, that''s perfect timing - I''ve been looking at our monthly statements and wondering if we can do better on the income side. The dividend payments are helpful, but I''m not sure they''re keeping up with our expenses the way I''d hoped.
Michael Thompson: Let me pull up your current numbers, James. You''re generating about $7,300 per month in dividend income from your portfolio, which annualizes to about $87,600. Your target was $150,000 annually, so we''re currently at about 58% of where you want to be. Is that consistent with what you''re seeing in your monthly cash flow?
James Anderson: That sounds about right. We''re supplementing with some of our other retirement accounts, but I''d really like to get the dividend income up to that $150,000 level if possible. What are our options?
Michael Thompson: Great question. Let me walk through a few approaches. First, we could increase your allocation to dividend-focused investments. You''re currently getting about a 3.0% dividend yield on average, but there are quality companies yielding 4-5% that might fit your risk profile.
James Anderson: What kind of companies are we talking about? I don''t want to chase yield and end up with risky investments.
Michael Thompson: Absolutely right to be cautious about that, James. I''m thinking about what we call ''dividend aristocrats'' - companies that have increased their dividends for 25+ consecutive years. Think utilities like NextEra Energy yielding about 4.2%, consumer staples like Coca-Cola around 3.1% but with a long history of increases, and some REITs that focus on high-quality properties.
James Anderson: REITs are interesting - real estate investment trusts, right? How do those work exactly?
Michael Thompson: Exactly. REITs own and operate income-producing real estate - office buildings, shopping centers, apartments, data centers. By law, they have to distribute 90% of their taxable income to shareholders, which is why they typically offer higher yields. We''d want to focus on REITs with high-quality properties and strong management teams.
James Anderson: That makes sense. What kind of yields do REITs typically offer?
Michael Thompson: Quality REITs are currently yielding anywhere from 4-7%, depending on the property type and quality. For instance, data center REITs serving cloud computing companies might yield 4-5% but offer growth potential, while more traditional office REITs might yield 6-7% but face headwinds from remote work trends.
James Anderson: I like the idea of data centers - that seems like a growing business. What else should we be considering?
Michael Thompson: Another option is dividend-focused ETFs that do the security selection for us. These funds screen for companies with strong dividend histories, reasonable payout ratios, and growing cash flows. They typically yield 3-4% but provide instant diversification across dozens or hundreds of dividend-paying stocks.
James Anderson: That sounds more conservative than picking individual REITs or stocks. What''s the trade-off?
Michael Thompson: The ETF approach gives you broader diversification and professional management, but you''ll get average results rather than the potential for outperformance. With individual stocks and REITs, you have more potential upside if we pick well, but also more concentration risk if any single holding runs into trouble.
James Anderson: Given my age and the fact that I''m relying on this income, I think I lean toward the more diversified approach. What kind of allocation change would we be looking at?
Michael Thompson: Currently you''re about 35% equities, 55% bonds, 10% cash. I''m thinking we could adjust to maybe 45% equities with a focus on dividend payers, 40% bonds including some higher-yielding corporate bonds, 10% REITs, and 5% cash. This should bump your overall yield from 3.0% to around 4.2-4.5%.
James Anderson: That would get me closer to my $150,000 target. What would 4.5% yield on my current portfolio value?
Michael Thompson: On your current $2.9 million portfolio, 4.5% would generate about $130,500 annually, or roughly $10,875 per month. That''s a meaningful increase from your current $7,300 monthly income.
James Anderson: That''s much better! What about the risks of this approach? I don''t want to jeopardize the principal in pursuit of higher income.
Michael Thompson: Good question to ask, James. The main risks are that dividend-paying stocks can still decline in value during market downturns, and some companies might cut their dividends if they run into financial trouble. However, by focusing on companies with long dividend histories and diversifying across sectors, we can minimize these risks.
James Anderson: What about interest rate risk? If rates go up, don''t dividend stocks typically perform poorly?
Michael Thompson: You''re right that there''s some interest rate sensitivity, but it''s typically less than with bonds. Many dividend-paying companies can actually benefit from rising rates if it indicates a strong economy. And some sectors like banks actually perform better in rising rate environments.
James Anderson: This all sounds reasonable to me. What''s the timeline for making these changes?
Michael Thompson: I''d suggest we implement this over 4-6 weeks to avoid any market timing issues. We''ll gradually shift from some of your lower-yielding positions into the higher-income alternatives. I''ll also prepare a detailed analysis showing you exactly which securities we''d be adding and their dividend histories.
James Anderson: Perfect. One last question - what about taxes on all this dividend income? I know qualified dividends get favorable treatment, but I want to make sure we''re being tax-efficient.
Michael Thompson: Excellent point. Most of the dividends from the stocks we''d be buying qualify for the preferential 15% tax rate rather than ordinary income rates. For the REITs, those distributions are typically taxed as ordinary income, but we might want to consider holding those in your IRA to defer the taxes.
James Anderson: That makes sense. I like this plan, Michael. It addresses my income needs while still being appropriately conservative for my situation.
Michael Thompson: Great, James. I''ll put together the detailed proposal and we can review it next week before starting the implementation.
James Anderson: Sounds good, thanks for staying focused on my income requirements. This should make our monthly cash flow much more comfortable.', '2024-11-08'),
('C004', '2024-10-18', 29, 'Michael Thompson: Hi Emily, thanks for making time today. I wanted to touch base about your portfolio performance and discuss a potential tax planning opportunity I''ve identified.
Emily Rodriguez: Hi Michael, good to hear from you. Tax planning sounds important - I have to admit I don''t think about taxes as much as I probably should when it comes to my investments.
Michael Thompson: That''s completely normal, Emily - most people focus on returns first and taxes second. But especially for younger investors like yourself who are in higher tax brackets, tax-efficient investing can make a meaningful difference in your long-term wealth building.
Emily Rodriguez: I''m listening. What kind of opportunity are you seeing?
Michael Thompson: Well, you''re up about 15.2% year-to-date, which is excellent performance. But I notice you have some positions that are underwater - specifically some growth stocks that have declined since we purchased them earlier this year. We could harvest those tax losses before year-end to offset other gains and reduce your tax bill.
Emily Rodriguez: Tax loss harvesting - I''ve heard the term but never really understood how it works. Can you explain?
Michael Thompson: Sure! The basic idea is that when you sell investments at a loss, you can use those losses to offset capital gains from other investments. Any excess losses can offset up to $3,000 of ordinary income per year, and any remaining losses carry forward to future years.
Emily Rodriguez: So we''d be selling my losing investments? Doesn''t that mean we''re locking in the losses?
Michael Thompson: That''s the key question, Emily. If we still believe in the long-term prospects of those companies or sectors, we can sell the specific positions at a loss and then immediately buy similar - but not identical - investments. This way we maintain our market exposure while capturing the tax benefits.
Emily Rodriguez: Can you give me a specific example from my portfolio?
Michael Thompson: Absolutely. You have a position in Shopify that''s down about $4,000 from your purchase price. E-commerce and digital payments are still long-term growth themes we believe in, but Shopify specifically has faced some headwinds. We could sell Shopify at a loss and immediately buy a broader e-commerce ETF or another e-commerce stock like Amazon. You''d maintain exposure to the theme while harvesting the loss.
Emily Rodriguez: That makes sense. What about the $3,000 ordinary income offset you mentioned - is that significant?
Michael Thompson: For someone in your tax bracket, that $3,000 deduction is worth about $1,100 in actual tax savings. It''s not life-changing money, but it''s meaningful, and if we harvest more losses than that, the excess carries forward to benefit you in future years when you have capital gains to offset.
Emily Rodriguez: Are there any rules I need to be aware about this?
Michael Thompson: Good question! The main rule is called the ''wash sale rule.'' You can''t buy the exact same security within 30 days before or after selling it at a loss, or the IRS will disallow the tax loss. That''s why we''d need to buy similar but not identical investments if we want to maintain market exposure.
Emily Rodriguez: Got it. What other positions might be candidates for this strategy?
Michael Thompson: Looking at your portfolio, you also have some small losses in a couple of technology stocks that haven''t performed as expected. In total, I''m seeing about $6,000 in harvestable losses, which would offset the $3,000 of ordinary income this year and give you $3,000 to carry forward.
Emily Rodriguez: That sounds worthwhile. What''s the timeline for doing this? Do we need to complete everything before year-end?
Michael Thompson: Exactly - any tax loss harvesting needs to be completed by December 31st to count for this tax year. I''d recommend we implement these changes in the next few weeks to avoid any last-minute rush in December when trading volumes can be higher and prices more volatile.
Emily Rodriguez: This makes sense to me. Are there any downsides or risks I should be aware of?
Michael Thompson: The main consideration is that we''ll have slightly different investments after the harvesting - similar exposure but not identical positions. There''s also the possibility that the stocks we sell recover strongly right after we sell them, though we''d still benefit from owning similar investments.
Emily Rodriguez: I understand. What about going forward - is this something we should be doing regularly?
Michael Thompson: For investors in higher tax brackets like yourself, yes, tax loss harvesting can be a valuable annual strategy. Many successful investors review their portfolios each October/November specifically looking for harvesting opportunities. Over time, the tax savings can compound significantly.
Emily Rodriguez: That''s good to know. I want to make sure I''m being as tax-efficient as possible, especially while I''m in a high-earning phase of my career.
Michael Thompson: Exactly the right mindset, Emily. The tax savings from strategies like this can be reinvested to grow your wealth even faster. It''s one of the advantages of working with a proactive advisor rather than just buying and holding individual stocks.
Emily Rodriguez: I appreciate that you''re thinking about these opportunities proactively rather than waiting for me to ask. What''s the next step?
Michael Thompson: I''ll prepare a detailed analysis showing exactly which positions I''d recommend selling, what we''d replace them with, and the estimated tax benefits. We can review that together and then execute the trades once you''re comfortable with the plan.
Emily Rodriguez: Perfect. How soon can you have that analysis ready?
Michael Thompson: I''ll have it to you by early next week, and we can implement before the end of the month. This should save you some meaningful money on your tax bill while keeping your portfolio positioned for continued growth.
Emily Rodriguez: Excellent, thanks Michael. I''m glad we''re being proactive about tax planning - it''s an area where I definitely need the professional guidance.', '2024-10-18'),
('C006', '2024-08-15', 26, 'Michael Thompson: Hi Lisa, I hope you''re having a good summer. I wanted to check in about your twins'' college planning - I know they''re going to be seniors this year and we should start thinking about the final preparations.
Lisa Thompson: Hi Michael, yes, I can''t believe they''re going to be seniors! It feels like just yesterday we were starting their 529 plans. I have to admit I''m getting a bit nervous about whether we''ve saved enough and what the actual process looks like for accessing the money.
Michael Thompson: That''s completely natural - this is a big financial milestone for your family. Let me give you the current status and then we can talk through the logistics. Your education savings are currently at about $295,000, which puts you at roughly 49% of your $600,000 target for both children.
Lisa Thompson: So we''re about halfway there with one year left to save. That''s... concerning. What are our options?
Michael Thompson: First, don''t panic, Lisa. You''re in a better position than many families. Let''s think through this systematically. Between now and when they graduate, we can continue adding to the savings - you''re currently contributing $1,200 per month, which will add about $14,000 over the next year. We could potentially increase that contribution if your budget allows.
Lisa Thompson: We could probably bump it up some. My husband got a raise this year, and we''ve been pretty disciplined about living below our means. What would you suggest?
Michael Thompson: If you could increase to $1,800 per month for this final year, that would add about $21,000 instead of $14,000. Every extra dollar at this point has immediate impact since they''ll be starting college soon.
Lisa Thompson: That''s definitely doable. What else should we be considering?
Michael Thompson: The other big factor is college costs themselves. Have the twins started thinking about where they want to apply? The difference between in-state public universities and private colleges is substantial - we''re talking $25,000-30,000 per year versus $60,000-70,000 per year all-in.
Lisa Thompson: They''re both bright kids, so they''re looking at a range of schools. My daughter is interested in journalism and looking at places like Northwestern and Mizzou. My son wants to study engineering and is considering University of Illinois, Purdue, and maybe some private schools like Northwestern too.
Michael Thompson: That''s a good mix of options. Schools like Illinois and Purdue would be much more affordable - probably $30,000-35,000 per year total cost. Northwestern would be closer to $75,000 per year. Have you talked with them about the financial realities?
Lisa Thompson: We''ve touched on it, but I don''t want to limit their dreams if we can avoid it. At the same time, I don''t want to saddle them with massive debt.
Michael Thompson: That''s the balance every family has to strike, Lisa. Here''s one way to think about it: with your current savings trajectory, you''ll have enough to fully fund four years at excellent public universities for both children. For private schools, you''d need to supplement with loans, work-study, or merit aid.
Lisa Thompson: What about financial aid? We haven''t really explored that yet.
Michael Thompson: Definitely worth exploring. You''ll want to file the FAFSA - Free Application for Federal Student Aid - by early next year. With your income level, you might not qualify for need-based aid at many schools, but there are merit-based scholarships to consider. Some schools also have more generous aid programs than others.
Lisa Thompson: I''ve heard the FAFSA is complicated. Is that something you can help with?
Michael Thompson: I can point you to resources and help you understand how your assets might impact aid calculations, but you''ll probably want to work with a college funding specialist for the detailed FAFSA strategy. There are ways to optimize the timing of income and asset positioning that can impact aid eligibility.
Lisa Thompson: That sounds helpful. What about accessing the 529 money when the time comes - how does that work?
Michael Thompson: It''s actually quite straightforward. You can withdraw money from the 529 plans tax-free as long as it''s used for qualified education expenses - tuition, fees, room and board, textbooks, even computers if required. You just need to keep receipts and documentation.
Lisa Thompson: What happens if we don''t use all the 529 money? I know that''s probably not going to be our problem, but I''m curious.
Michael Thompson: If there''s money left over, you have several options: you can transfer it to other family members for their education, save it for graduate school, or withdraw it and pay taxes plus a 10% penalty on the earnings portion. But as you said, that''s probably not going to be your situation!
Lisa Thompson: Right! What about the order of withdrawals - should I use 529 money first, or other savings?
Michael Thompson: Generally, you want to use the 529 money first since that comes out completely tax-free for qualified expenses. Any additional funding needs would come from your regular savings, which might have some tax implications depending on what we sell.
Lisa Thompson: This is helpful, Michael. I feel like I have a better handle on what we need to do. Can you send me some information about college funding specialists in the area?
Michael Thompson: Absolutely. I''ll send you a couple of referrals to specialists who work specifically with families in your situation. They can help with both the financial aid strategy and optimizing your savings in this final year.
Lisa Thompson: Perfect. I really appreciate you staying on top of this timeline. It''s easy to put off thinking about it when the kids are younger, but now it''s very real!
Michael Thompson: That''s exactly why we set up systematic saving early on, Lisa. You''ve done a great job building up these education funds over the years. We just need to optimize the final stretch and make smart decisions about school selection.
Lisa Thompson: Thanks Michael. I''ll follow up with one of those specialists and we can regroup in a few months once we have more clarity on college applications and aid possibilities.', '2024-08-15');

-- Insert client financial goals and preferences for all clients
-- Each record represents a specific financial goal (retirement, education, wealth preservation, etc.)
-- Includes target values, timelines, priority levels, progress tracking, and risk tolerance
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_GOALS_PREFERENCES 
(CLIENT_ID, GOAL_ID, GOAL_TYPE, GOAL_DESCRIPTION, TARGET_VALUE, TARGET_DATE, PRIORITY, CURRENT_PROGRESS, RISK_TOLERANCE_GOAL, NOTES)
VALUES 
('C001', 'G001', 'Retirement', 'Retirement Planning', 5000000, '2039-12-31', 'High', 57.0, 'Moderate', 'Target 5M by age 60 for comfortable retirement'),
('C001', 'G002', 'Education', 'Children''s College Fund', 800000, '2032-08-31', 'High', 35.6, 'Moderate-Conservative', 'Two children - need 400K each for top universities'),
('C001', 'G003', 'Wealth Preservation', 'Estate Planning', 3000000, '2044-12-31', 'Medium', 108.2, 'Conservative', 'Preserve wealth for next generation'),
('C001', 'G004', 'Income', 'Dividend Income', 120000, '2029-12-31', 'Medium', 28.5, 'Moderate', 'Annual dividend income goal of 120K by age 55'),
('C001', 'G005', 'Philanthropy', 'Charitable Giving', 1000000, '2044-12-31', 'Low', 0.0, 'N/A', 'Establish charitable foundation later in life'),
('C002', 'G006', 'Wealth Accumulation', 'Early Retirement', 3000000, '2036-12-31', 'High', 61.7, 'Aggressive', 'Target early retirement by age 50'),
('C002', 'G007', 'Real Estate', 'Investment Property', 500000, '2027-12-31', 'Medium', 35.0, 'Moderate', 'Down payment for rental property investment'),
('C003', 'G008', 'Retirement', 'Current Retirement Income', 150000, '2025-12-31', 'High', 85.3, 'Conservative', 'Maintain current lifestyle in retirement'),
('C003', 'G009', 'Healthcare', 'Long-term Care Fund', 300000, '2030-12-31', 'High', 42.1, 'Conservative', 'Prepare for potential healthcare costs'),
('C004', 'G010', 'Home Purchase', 'First Home Down Payment', 200000, '2026-08-31', 'High', 47.5, 'Moderate', '20% down payment on primary residence'),
('C004', 'G011', 'Retirement', 'Long-term Retirement', 2500000, '2054-12-31', 'Medium', 38.0, 'Moderate-Aggressive', 'Maximize growth for long-term wealth'),
('C005', 'G012', 'Retirement', 'Pre-retirement Bridge', 4500000, '2029-12-31', 'High', 91.0, 'Moderate-Conservative', 'Bridge to full retirement at 60'),
('C005', 'G013', 'Education', 'Children''s Graduate School', 400000, '2027-06-30', 'Medium', 51.2, 'Moderate', 'MBA funding for two children'),
('C006', 'G014', 'Education', 'Twin College Fund', 600000, '2035-08-31', 'High', 31.0, 'Moderate', 'College funding for twins born 2006'),
('C006', 'G015', 'Retirement', 'Retirement Planning', 3500000, '2044-12-31', 'High', 53.2, 'Moderate', 'Comfortable retirement by age 65'),
('C007', 'G016', 'Income', 'Retirement Income', 200000, '2025-01-31', 'High', 72.2, 'Conservative', 'Maintain income in full retirement'),
('C007', 'G017', 'Legacy', 'Estate for Grandchildren', 1000000, '2040-12-31', 'Medium', 58.9, 'Conservative', 'Education fund for 4 grandchildren'),
('C008', 'G018', 'Wealth Accumulation', 'Financial Independence', 2000000, '2038-12-31', 'High', 55.3, 'Aggressive', 'Achieve financial independence by age 45'),
('C008', 'G019', 'Business', 'Startup Investment Fund', 150000, '2026-12-31', 'Medium', 36.7, 'Aggressive', 'Fund for potential business ventures');

-- Insert priority alerts for advisor attention on client portfolio issues and opportunities
-- Each alert identifies portfolio concerns (underperformance, concentration risk, rebalancing needs)
-- Includes recommended actions, urgency levels, and time estimates for resolution
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_PRIORITY_ALERTS 
(ADVISOR_ID, CLIENT_ID, ALERT_TYPE, PRIORITY_LEVEL, ALERT_DESCRIPTION, DAYS_SINCE_ALERT, RECOMMENDED_ACTION, ESTIMATED_TIME_TO_RESOLVE, LAST_CONTACT_DATE)
VALUES 
('ADV001', 'C003', 'Performance', 'High', 'Portfolio underperforming benchmark by 8.2% YTD', 15, 'Review and rebalance conservative allocation', 45, '2024-11-05'),
('ADV001', 'C002', 'Risk', 'High', 'Tech concentration at 65% - exceeds risk tolerance limits', 8, 'Diversify technology holdings across sectors', 30, '2024-10-22'),
('ADV001', 'C005', 'Rebalancing', 'Medium', 'Cash allocation at 10% - recommend deployment', 22, 'Invest excess cash according to IPS', 20, '2024-11-12'),
('ADV001', 'C008', 'Performance', 'Medium', 'High volatility portfolio - down 12% in past month', 5, 'Review risk tolerance and adjust if needed', 60, '2024-10-25'),
('ADV001', 'C007', 'Income', 'Medium', 'Dividend yield below target 4% - currently at 3.2%', 30, 'Increase dividend-focused positions', 25, '2024-11-08'),
('ADV001', 'C001', 'Review', 'Low', 'Quarterly review scheduled - no immediate issues', 3, 'Prepare standard quarterly review materials', 15, '2024-09-15'),
('ADV001', 'C006', 'Goal Progress', 'Low', 'Education goal 2% behind target pace', 12, 'Increase contributions or adjust allocation', 20, '2024-10-30'),
('ADV001', 'C004', 'Opportunity', 'Low', 'Tax loss harvesting opportunity in growth stocks', 18, 'Harvest losses before year-end', 10, '2024-10-18');

-- Insert client profile records for all clients managed by the advisor
-- Each record contains demographic information, risk profile, portfolio values, and relationship details
-- Includes investment objectives, portfolio size, and advisory relationship start date
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.CLIENT_PROFILE 
(CLIENT_ID, CLIENT_NAME, AGE, RISK_TOLERANCE, INVESTMENT_HORIZON_YEARS, TOTAL_PORTFOLIO_VALUE, CASH_BALANCE, INVESTMENT_GOALS, LAST_REVIEW_DATE, ADVISOR_ID, CLIENT_SINCE)
VALUES 
('C001', 'John Mitchell', 45, 'Moderate', 15, 2850000, 285000, 'Growth and Income', '2024-09-15', 'ADV001', '2019-03-15'),
('C002', 'Sarah Chen', 38, 'Aggressive', 25, 1750000, 87500, 'Capital Appreciation', '2024-10-22', 'ADV001', '2020-07-10'),
('C003', 'Robert Williams', 62, 'Conservative', 8, 3200000, 320000, 'Income and Preservation', '2024-11-05', 'ADV001', '2018-01-20'),
('C004', 'Emily Rodriguez', 29, 'Moderate-Aggressive', 30, 950000, 47500, 'Long-term Growth', '2024-10-18', 'ADV001', '2021-06-12'),
('C005', 'David Kim', 55, 'Moderate-Conservative', 10, 4100000, 410000, 'Pre-retirement Planning', '2024-11-12', 'ADV001', '2017-09-08'),
('C006', 'Lisa Thompson', 41, 'Moderate', 20, 1850000, 92500, 'Education and Retirement', '2024-10-30', 'ADV001', '2020-02-28'),
('C007', 'James Anderson', 67, 'Conservative', 5, 2900000, 290000, 'Income Generation', '2024-11-08', 'ADV001', '2016-11-15'),
('C008', 'Maria Gonzalez', 33, 'Aggressive', 28, 1100000, 55000, 'Wealth Accumulation', '2024-10-25', 'ADV001', '2021-12-03');

-- Insert historical performance metrics for client portfolios
-- Each record captures monthly snapshots of portfolio returns, values, and risk metrics
-- Includes benchmark comparisons (S&P 500), alpha, Sharpe ratio, drawdown, and volatility measures
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.PERFORMANCE_METRICS 
(CLIENT_ID, PERIOD_END_DATE, PORTFOLIO_VALUE, PORTFOLIO_RETURN_MTD, PORTFOLIO_RETURN_YTD, PORTFOLIO_RETURN_1YR, SP500_RETURN_MTD, SP500_RETURN_YTD, SP500_RETURN_1YR, BENCHMARK_ALPHA, SHARPE_RATIO, MAX_DRAWDOWN, VOLATILITY)
VALUES 
('C001', '2022-01-31', 2850000, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.85, -5.2, 12.5),
('C001', '2022-02-28', 2798450, -1.8, -1.8, -1.8, -2.9, -2.9, -2.9, 1.1, 0.82, -5.2, 13.1),
('C001', '2022-03-31', 2741260, -2.0, -3.8, -3.8, -1.2, -4.0, -4.0, 0.2, 0.78, -7.4, 14.2),
('C001', '2022-04-30', 2695420, -1.7, -5.4, -5.4, -3.8, -7.6, -7.6, 2.2, 0.71, -8.8, 15.1),
('C001', '2022-05-31', 2709840, 0.5, -4.9, -4.9, -0.5, -8.1, -8.1, 3.2, 0.73, -8.8, 14.9),
('C001', '2022-06-30', 2568950, -5.2, -9.9, -9.9, -8.2, -15.6, -15.6, 5.7, 0.65, -12.1, 16.8),
('C001', '2022-07-31', 2591430, 0.9, -9.1, -9.1, 9.1, -7.1, -7.1, -2.0, 0.68, -12.1, 16.2),
('C001', '2022-08-31', 2653210, 2.4, -6.9, -6.9, -0.2, -7.3, -7.3, 0.4, 0.72, -12.1, 15.7),
('C001', '2022-09-30', 2589470, -2.4, -9.1, -9.1, -9.3, -16.0, -16.0, 6.9, 0.67, -13.5, 17.1),
('C001', '2022-10-31', 2501320, -3.4, -12.2, -12.2, 8.1, -9.2, -9.2, -3.0, 0.61, -15.8, 18.4),
('C001', '2022-11-30', 2566890, 2.6, -9.9, -9.9, 5.4, -4.7, -4.7, -5.2, 0.65, -15.8, 17.9),
('C001', '2022-12-31', 2548120, -0.7, -10.6, -10.6, -5.9, -10.1, -10.1, -0.5, 0.63, -15.8, 17.8),
('C001', '2023-01-31', 2572450, 1.0, -9.7, -9.7, 6.2, -4.7, -4.7, -5.0, 0.65, -15.8, 17.3),
('C001', '2023-02-28', 2648310, 2.9, -7.1, -7.1, -2.6, -7.1, -7.1, 0.0, 0.69, -15.8, 16.8),
('C001', '2023-03-31', 2705820, 2.2, -5.1, -5.1, 3.5, -3.8, -3.8, -1.3, 0.72, -15.8, 16.2),
('C001', '2023-04-30', 2731950, 1.0, -4.2, -4.2, 1.5, -2.4, -2.4, -1.8, 0.73, -15.8, 15.9),
('C001', '2023-05-31', 2741870, 0.4, -3.8, -3.8, 0.4, -2.0, -2.0, -1.8, 0.74, -15.8, 15.7),
('C001', '2023-06-30', 2812450, 2.6, -1.3, -1.3, 6.5, 4.2, 4.2, -5.5, 0.77, -15.8, 15.2),
('C001', '2023-07-31', 2859240, 1.7, 0.3, 0.3, 3.1, 7.5, 7.5, -7.2, 0.79, -15.8, 14.8),
('C001', '2023-08-31', 2835670, -0.8, -0.5, -0.5, -1.8, 5.5, 5.5, -6.0, 0.78, -15.8, 14.9),
('C001', '2023-09-30', 2769180, -2.3, -2.8, -2.8, -4.9, 0.2, 0.2, -3.0, 0.75, -17.2, 15.4),
('C001', '2023-10-31', 2741960, -1.0, -3.8, -3.8, -2.1, -1.9, -1.9, -1.9, 0.74, -17.2, 15.6),
('C001', '2023-11-30', 2826850, 3.1, -0.8, -0.8, 9.1, 7.0, 7.0, -6.1, 0.77, -17.2, 15.1),
('C001', '2023-12-31', 2867420, 1.4, 0.6, 0.6, 4.5, 12.0, 12.0, -11.4, 0.79, -17.2, 14.8),
('C001', '2024-01-31', 2893750, 0.9, 1.6, 1.6, 1.6, 1.6, 1.6, 0.0, 0.80, -17.2, 14.6),
('C001', '2024-02-29', 2951340, 2.0, 3.6, 3.6, 5.3, 7.0, 7.0, -3.4, 0.82, -17.2, 14.2),
('C001', '2024-03-31', 2989870, 1.3, 4.9, 4.9, 3.1, 10.6, 10.6, -5.7, 0.83, -17.2, 13.9),
('C001', '2024-04-30', 2934560, -1.9, 3.0, 3.0, -4.1, 5.9, 5.9, -2.9, 0.81, -18.1, 14.1),
('C001', '2024-05-31', 3021480, 3.0, 6.0, 6.0, 4.8, 11.3, 11.3, -5.3, 0.84, -18.1, 13.7),
('C001', '2024-06-30', 3067950, 1.5, 7.6, 7.6, 3.5, 15.3, 15.3, -7.7, 0.85, -18.1, 13.4),
('C001', '2024-07-31', 3125670, 1.9, 9.7, 9.7, 1.2, 16.9, 16.9, -7.2, 0.87, -18.1, 13.1),
('C001', '2024-08-31', 3089420, -1.2, 8.4, 8.4, -0.6, 16.1, 16.1, -7.7, 0.86, -18.7, 13.3),
('C001', '2024-09-30', 3156840, 2.2, 10.8, 10.8, 0.0, 16.1, 16.1, -5.3, 0.88, -18.7, 13.0),
('C001', '2024-10-31', 3198750, 1.3, 12.3, 12.3, -1.0, 15.0, 15.0, -2.7, 0.89, -18.7, 12.8),
('C001', '2024-11-30', 3234570, 1.1, 13.5, 13.5, 5.7, 21.8, 21.8, -8.3, 0.90, -18.7, 12.6),
('C001', '2024-12-01', 3245680, 0.3, 13.9, 13.9, 2.0, 24.4, 24.4, -10.5, 0.91, -18.7, 12.5),
('C002', '2024-12-01', 1837500, 1.8, 18.5, 22.3, 2.0, 24.4, 24.4, -5.9, 1.15, -15.2, 18.7),
('C003', '2024-12-01', 3198750, -0.5, 4.2, 6.8, 2.0, 24.4, 24.4, -20.2, 0.65, -12.8, 8.9),
('C004', '2024-12-01', 996850, 2.1, 15.2, 18.9, 2.0, 24.4, 24.4, -9.2, 0.98, -16.3, 14.2),
('C005', '2024-12-01', 4089250, 0.8, 8.7, 9.5, 2.0, 24.4, 24.4, -15.7, 0.78, -11.5, 10.3),
('C006', '2024-12-01', 1867320, 1.2, 11.8, 13.2, 2.0, 24.4, 24.4, -12.6, 0.85, -14.1, 11.8),
('C007', '2024-12-01', 2896450, 0.4, 5.8, 7.2, 2.0, 24.4, 24.4, -18.6, 0.72, -8.9, 7.5),
('C008', '2024-12-01', 1105680, -2.1, 12.8, 15.6, 2.0, 24.4, 24.4, -11.6, 1.08, -22.4, 21.3);

-- Insert current portfolio holdings for all clients
-- Each record represents an individual security position within a client's portfolio
-- Includes position details (shares, cost basis, current value), asset classification, and allocation percentages
INSERT INTO FINANCIAL_ADVISOR_DEMO_DB.ANALYTICS.PORTFOLIO_HOLDINGS 
(CLIENT_ID, ASSET_SYMBOL, ASSET_NAME, ASSET_CLASS, SECTOR, SHARES_HELD, AVG_COST_BASIS, CURRENT_PRICE, MARKET_VALUE, ALLOCATION_PERCENTAGE, PURCHASE_DATE, LAST_UPDATED)
VALUES 
('C001', 'AAPL', 'Apple Inc', 'Equity', 'Technology', 1250, 145.50, 198.50, 248125, 8.7, '2022-01-15', '2024-12-01'),
('C001', 'MSFT', 'Microsoft Corporation', 'Equity', 'Technology', 950, 285.00, 415.25, 394488, 13.8, '2022-01-20', '2024-12-01'),
('C001', 'GOOGL', 'Alphabet Inc', 'Equity', 'Technology', 280, 105.75, 171.50, 48020, 1.7, '2022-02-10', '2024-12-01'),
('C001', 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 1800, 165.25, 148.75, 267750, 9.4, '2022-01-25', '2024-12-01'),
('C001', 'JPM', 'JPMorgan Chase & Co', 'Equity', 'Financials', 1200, 135.50, 231.75, 278100, 9.8, '2022-02-01', '2024-12-01'),
('C001', 'PFE', 'Pfizer Inc', 'Equity', 'Healthcare', 2500, 52.25, 25.50, 63750, 2.2, '2022-03-01', '2024-12-01'),
('C001', 'V', 'Visa Inc', 'Equity', 'Financials', 400, 215.00, 295.50, 118200, 4.1, '2022-02-15', '2024-12-01'),
('C001', 'ICLN', 'iShares Global Clean Energy ETF', 'ETF', 'Clean Energy', 3500, 22.50, 18.75, 65625, 2.3, '2022-04-01', '2024-12-01'),
('C001', 'BOTZ', 'Global X Robotics & AI ETF', 'ETF', 'Technology', 1800, 28.75, 32.50, 58500, 2.1, '2022-05-15', '2024-12-01'),
('C001', 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 'Broad Market', 800, 195.50, 285.25, 228200, 8.0, '2022-01-10', '2024-12-01'),
('C001', 'VXUS', 'Vanguard Total Intl Stock ETF', 'ETF', 'International', 2200, 58.75, 65.50, 144100, 5.1, '2022-03-15', '2024-12-01'),
('C001', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 4500, 75.25, 73.50, 330750, 11.6, '2022-01-30', '2024-12-01'),
('C001', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 2800, 51.50, 50.25, 140700, 4.9, '2022-02-20', '2024-12-01'),
('C001', 'TIP', 'iShares TIPS Bond ETF', 'Bond', 'Treasury', 1500, 118.75, 103.50, 155250, 5.4, '2022-06-01', '2024-12-01'),
('C001', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 285000, 1.00, 1.00, 285000, 10.0, '2024-01-01', '2024-12-01'),
('C002', 'TSLA', 'Tesla Inc', 'Equity', 'Technology', 450, 215.00, 248.50, 111825, 6.4, '2020-08-15', '2024-12-01'),
('C002', 'NVDA', 'NVIDIA Corporation', 'Equity', 'Technology', 800, 85.50, 145.25, 116200, 6.6, '2021-02-10', '2024-12-01'),
('C002', 'AMZN', 'Amazon.com Inc', 'Equity', 'Consumer Discretionary', 350, 145.75, 185.50, 64925, 3.7, '2020-09-20', '2024-12-01'),
('C002', 'META', 'Meta Platforms Inc', 'Equity', 'Technology', 600, 275.00, 485.25, 291150, 16.6, '2021-01-25', '2024-12-01'),
('C002', 'GOOGL', 'Alphabet Inc', 'Equity', 'Technology', 800, 125.75, 171.50, 137200, 7.8, '2021-03-15', '2024-12-01'),
('C002', 'NFLX', 'Netflix Inc', 'Equity', 'Technology', 200, 385.50, 485.75, 97150, 5.5, '2021-04-01', '2024-12-01'),
('C002', 'SHOP', 'Shopify Inc', 'Equity', 'Technology', 400, 125.25, 95.50, 38200, 2.2, '2021-06-10', '2024-12-01'),
('C002', 'QQQ', 'Invesco QQQ Trust', 'ETF', 'Technology', 600, 325.00, 485.75, 291450, 16.7, '2020-07-15', '2024-12-01'),
('C002', 'VUG', 'Vanguard Growth ETF', 'ETF', 'Growth', 400, 265.50, 385.25, 154100, 8.8, '2020-11-20', '2024-12-01'),
('C002', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 1200, 78.25, 73.50, 88200, 5.0, '2021-01-30', '2024-12-01'),
('C002', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 800, 52.50, 50.25, 40200, 2.3, '2021-02-15', '2024-12-01'),
('C002', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 87500, 1.00, 1.00, 87500, 5.0, '2024-01-01', '2024-12-01'),
('C003', 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 2000, 158.75, 148.75, 297500, 9.3, '2018-03-15', '2024-12-01'),
('C003', 'PG', 'Procter & Gamble', 'Equity', 'Consumer Staples', 1500, 125.50, 165.25, 247875, 7.7, '2018-04-20', '2024-12-01'),
('C003', 'KO', 'Coca-Cola Company', 'Equity', 'Consumer Staples', 3000, 52.75, 58.50, 175500, 5.5, '2018-05-10', '2024-12-01'),
('C003', 'PFE', 'Pfizer Inc', 'Equity', 'Healthcare', 4000, 45.25, 25.50, 102000, 3.2, '2018-06-01', '2024-12-01'),
('C003', 'VZ', 'Verizon Communications', 'Equity', 'Telecommunications', 2500, 58.75, 42.25, 105625, 3.3, '2018-07-15', '2024-12-01'),
('C003', 'T', 'AT&T Inc', 'Equity', 'Telecommunications', 3500, 32.50, 22.50, 78750, 2.5, '2018-08-20', '2024-12-01'),
('C003', 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 'Broad Market', 600, 185.50, 285.25, 171150, 5.3, '2018-02-10', '2024-12-01'),
('C003', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 8000, 76.25, 73.50, 588000, 18.4, '2018-01-25', '2024-12-01'),
('C003', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 6000, 53.75, 50.25, 301500, 9.4, '2018-03-30', '2024-12-01'),
('C003', 'TIP', 'iShares TIPS Bond ETF', 'Bond', 'Treasury', 4000, 115.50, 103.50, 414000, 12.9, '2018-05-15', '2024-12-01'),
('C003', 'LQD', 'iShares Investment Grade Corp Bond ETF', 'Bond', 'Corporate', 2500, 125.75, 118.50, 296250, 9.3, '2018-06-30', '2024-12-01'),
('C003', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 320000, 1.00, 1.00, 320000, 10.0, '2024-01-01', '2024-12-01'),
('C004', 'AAPL', 'Apple Inc', 'Equity', 'Technology', 600, 165.50, 198.50, 119100, 12.5, '2021-07-15', '2024-12-01'),
('C004', 'MSFT', 'Microsoft Corporation', 'Equity', 'Technology', 300, 325.00, 415.25, 124575, 13.1, '2021-08-20', '2024-12-01'),
('C004', 'AMZN', 'Amazon.com Inc', 'Equity', 'Consumer Discretionary', 200, 155.75, 185.50, 37100, 3.9, '2021-09-10', '2024-12-01'),
('C004', 'TSLA', 'Tesla Inc', 'Equity', 'Technology', 150, 195.50, 248.50, 37275, 3.9, '2021-10-05', '2024-12-01'),
('C004', 'V', 'Visa Inc', 'Equity', 'Financials', 200, 225.00, 295.50, 59100, 6.2, '2021-11-15', '2024-12-01'),
('C004', 'MA', 'Mastercard Inc', 'Equity', 'Financials', 150, 365.50, 485.75, 72862, 7.7, '2021-12-01', '2024-12-01'),
('C004', 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 'Broad Market', 300, 215.50, 285.25, 85575, 9.0, '2021-06-30', '2024-12-01'),
('C004', 'VXUS', 'Vanguard Total Intl Stock ETF', 'ETF', 'International', 800, 62.75, 65.50, 52400, 5.5, '2021-08-15', '2024-12-01'),
('C004', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 1500, 77.50, 73.50, 110250, 11.6, '2021-07-01', '2024-12-01'),
('C004', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 1000, 53.25, 50.25, 50250, 5.3, '2021-09-20', '2024-12-01'),
('C004', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 47500, 1.00, 1.00, 47500, 5.0, '2024-01-01', '2024-12-01'),
('C005', 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 2500, 155.50, 148.75, 371875, 9.1, '2017-10-15', '2024-12-01'),
('C005', 'PG', 'Procter & Gamble', 'Equity', 'Consumer Staples', 2000, 135.75, 165.25, 330500, 8.1, '2017-11-20', '2024-12-01'),
('C005', 'KO', 'Coca-Cola Company', 'Equity', 'Consumer Staples', 3500, 48.25, 58.50, 204750, 5.0, '2017-12-10', '2024-12-01'),
('C005', 'JPM', 'JPMorgan Chase & Co', 'Equity', 'Financials', 1500, 125.50, 231.75, 347625, 8.5, '2018-01-15', '2024-12-01'),
('C005', 'BAC', 'Bank of America', 'Equity', 'Financials', 4000, 32.75, 44.25, 177000, 4.3, '2018-02-20', '2024-12-01'),
('C005', 'WMT', 'Walmart Inc', 'Equity', 'Consumer Staples', 1200, 135.50, 185.25, 222300, 5.4, '2018-03-15', '2024-12-01'),
('C005', 'VYM', 'Vanguard High Dividend Yield ETF', 'ETF', 'Dividend', 2000, 95.50, 125.75, 251500, 6.1, '2017-09-30', '2024-12-01'),
('C005', 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 'Broad Market', 800, 185.75, 285.25, 228200, 5.6, '2017-10-25', '2024-12-01'),
('C005', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 6500, 77.25, 73.50, 477750, 11.7, '2017-09-15', '2024-12-01'),
('C005', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 4500, 54.25, 50.25, 226125, 5.5, '2017-11-30', '2024-12-01'),
('C005', 'TIP', 'iShares TIPS Bond ETF', 'Bond', 'Treasury', 3500, 112.75, 103.50, 362250, 8.8, '2018-01-10', '2024-12-01'),
('C005', 'LQD', 'iShares Investment Grade Corp Bond ETF', 'Bond', 'Corporate', 2000, 128.50, 118.50, 237000, 5.8, '2018-04-05', '2024-12-01'),
('C005', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 410000, 1.00, 1.00, 410000, 10.0, '2024-01-01', '2024-12-01'),
('C006', 'AAPL', 'Apple Inc', 'Equity', 'Technology', 800, 155.75, 198.50, 158800, 8.6, '2020-03-15', '2024-12-01'),
('C006', 'MSFT', 'Microsoft Corporation', 'Equity', 'Technology', 400, 295.50, 415.25, 166100, 9.0, '2020-04-20', '2024-12-01'),
('C006', 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 1500, 168.75, 148.75, 223125, 12.1, '2020-05-10', '2024-12-01'),
('C006', 'V', 'Visa Inc', 'Equity', 'Financials', 300, 205.50, 295.50, 88650, 4.8, '2020-06-15', '2024-12-01'),
('C006', 'PG', 'Procter & Gamble', 'Equity', 'Consumer Staples', 1000, 125.75, 165.25, 165250, 8.9, '2020-07-20', '2024-12-01'),
('C006', 'UNH', 'UnitedHealth Group', 'Equity', 'Healthcare', 250, 385.50, 545.75, 136437, 7.4, '2020-08-25', '2024-12-01'),
('C006', 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 'Broad Market', 500, 195.75, 285.25, 142625, 7.7, '2020-02-28', '2024-12-01'),
('C006', 'VXUS', 'Vanguard Total Intl Stock ETF', 'ETF', 'International', 1200, 58.25, 65.50, 78600, 4.2, '2020-09-15', '2024-12-01'),
('C006', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 3500, 79.25, 73.50, 257250, 13.9, '2020-03-30', '2024-12-01'),
('C006', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 2500, 52.75, 50.25, 125625, 6.8, '2020-04-15', '2024-12-01'),
('C006', 'TIP', 'iShares TIPS Bond ETF', 'Bond', 'Treasury', 1200, 118.50, 103.50, 124200, 6.7, '2020-10-01', '2024-12-01'),
('C006', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 92500, 1.00, 1.00, 92500, 5.0, '2024-01-01', '2024-12-01'),
('C007', 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 1800, 152.75, 148.75, 267750, 9.2, '2016-12-15', '2024-12-01'),
('C007', 'PG', 'Procter & Gamble', 'Equity', 'Consumer Staples', 1500, 118.50, 165.25, 247875, 8.5, '2017-01-20', '2024-12-01'),
('C007', 'KO', 'Coca-Cola Company', 'Equity', 'Consumer Staples', 3000, 45.75, 58.50, 175500, 6.1, '2017-02-10', '2024-12-01'),
('C007', 'PFE', 'Pfizer Inc', 'Equity', 'Healthcare', 3500, 48.25, 25.50, 89250, 3.1, '2017-03-15', '2024-12-01'),
('C007', 'VZ', 'Verizon Communications', 'Equity', 'Telecommunications', 2000, 62.50, 42.25, 84500, 2.9, '2017-04-20', '2024-12-01'),
('C007', 'T', 'AT&T Inc', 'Equity', 'Telecommunications', 4000, 35.75, 22.50, 90000, 3.1, '2017-05-25', '2024-12-01'),
('C007', 'XOM', 'Exxon Mobil Corporation', 'Equity', 'Energy', 1200, 78.50, 118.75, 142500, 4.9, '2017-06-30', '2024-12-01'),
('C007', 'VYM', 'Vanguard High Dividend Yield ETF', 'ETF', 'Dividend', 1500, 88.75, 125.75, 188625, 6.5, '2016-11-30', '2024-12-01'),
('C007', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 8500, 75.50, 73.50, 624750, 21.5, '2016-12-01', '2024-12-01'),
('C007', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 5000, 53.25, 50.25, 251250, 8.7, '2017-01-15', '2024-12-01'),
('C007', 'TIP', 'iShares TIPS Bond ETF', 'Bond', 'Treasury', 3000, 115.75, 103.50, 310500, 10.7, '2017-03-01', '2024-12-01'),
('C007', 'LQD', 'iShares Investment Grade Corp Bond ETF', 'Bond', 'Corporate', 2500, 126.50, 118.50, 296250, 10.2, '2017-07-15', '2024-12-01'),
('C007', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 290000, 1.00, 1.00, 290000, 10.0, '2024-01-01', '2024-12-01'),
('C008', 'NVDA', 'NVIDIA Corporation', 'Equity', 'Technology', 600, 95.75, 145.25, 87150, 7.9, '2021-12-15', '2024-12-01'),
('C008', 'TSLA', 'Tesla Inc', 'Equity', 'Technology', 300, 185.50, 248.50, 74550, 6.8, '2022-01-20', '2024-12-01'),
('C008', 'META', 'Meta Platforms Inc', 'Equity', 'Technology', 400, 285.75, 485.25, 194100, 17.6, '2021-11-10', '2024-12-01'),
('C008', 'AMZN', 'Amazon.com Inc', 'Equity', 'Consumer Discretionary', 250, 165.50, 185.50, 46375, 4.2, '2021-10-15', '2024-12-01'),
('C008', 'NFLX', 'Netflix Inc', 'Equity', 'Technology', 150, 425.75, 485.75, 72862, 6.6, '2021-09-20', '2024-12-01'),
('C008', 'SHOP', 'Shopify Inc', 'Equity', 'Technology', 300, 145.50, 95.50, 28650, 2.6, '2022-02-25', '2024-12-01'),
('C008', 'SQ', 'Block Inc', 'Equity', 'Technology', 500, 125.75, 78.50, 39250, 3.6, '2021-08-30', '2024-12-01'),
('C008', 'ARKK', 'ARK Innovation ETF', 'ETF', 'Innovation', 800, 95.50, 52.75, 42200, 3.8, '2021-07-15', '2024-12-01'),
('C008', 'QQQ', 'Invesco QQQ Trust', 'ETF', 'Technology', 400, 365.50, 485.75, 194300, 17.7, '2021-12-01', '2024-12-01'),
('C008', 'VUG', 'Vanguard Growth ETF', 'ETF', 'Growth', 300, 285.75, 385.25, 115575, 10.5, '2021-11-25', '2024-12-01'),
('C008', 'BND', 'Vanguard Total Bond Market ETF', 'Bond', 'Government', 1000, 78.50, 73.50, 73500, 6.7, '2021-12-30', '2024-12-01'),
('C008', 'VTEB', 'Vanguard Tax-Exempt Bond ETF', 'Bond', 'Municipal', 600, 53.75, 50.25, 30150, 2.7, '2022-01-15', '2024-12-01'),
('C008', 'CASH', 'Cash & Money Market', 'Cash', 'Cash', 55000, 1.00, 1.00, 55000, 5.0, '2024-01-01', '2024-12-01');

SELECT 'Financial Advisor for Asset Management Demo setup complete' as message;