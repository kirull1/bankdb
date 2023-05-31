--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_customer(character, character, character, character, character, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_customer(IN p_login character, IN p_passhash character, IN p_name character, IN p_phone character, IN p_email character, IN p_registrationdate date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "Customers" (login, "passHash", name, phone, email, "registrationDate")
    VALUES (p_login, p_passHash, p_name, p_phone, p_email, p_registrationDate);
END;
$$;


ALTER PROCEDURE public.add_customer(IN p_login character, IN p_passhash character, IN p_name character, IN p_phone character, IN p_email character, IN p_registrationdate date) OWNER TO postgres;

--
-- Name: add_transaction(timestamp without time zone, numeric, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_transaction(IN p_datetime timestamp without time zone, IN p_amount numeric, IN p_account_id integer, IN p_type_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "Transactions" (datetime, amount, account_id, type_id)
    VALUES (p_datetime, p_amount, p_account_id, p_type_id);
END;
$$;


ALTER PROCEDURE public.add_transaction(IN p_datetime timestamp without time zone, IN p_amount numeric, IN p_account_id integer, IN p_type_id integer) OWNER TO postgres;

--
-- Name: get_customer_balances(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_customer_balances()
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT "Customers".id, "Customers".name, SUM("Accounts".balance) AS "Total Balance"
    FROM "Customers"
    INNER JOIN "Accounts" ON "Customers".id = "Accounts".customer_id
    GROUP BY "Customers".id, "Customers".name;
END;
$$;


ALTER PROCEDURE public.get_customer_balances() OWNER TO postgres;

--
-- Name: get_customers_by_registration_date(date, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_customers_by_registration_date(IN p_start_date date, IN p_end_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT * FROM "Customers" WHERE "registrationDate" BETWEEN p_start_date AND p_end_date;
END;
$$;


ALTER PROCEDURE public.get_customers_by_registration_date(IN p_start_date date, IN p_end_date date) OWNER TO postgres;

--
-- Name: update_account_balance(integer, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_account_balance(IN p_account_id integer, IN inp_new_balance numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE "Accounts" SET balance = p_new_balance WHERE id = p_account_id;
END;
$$;


ALTER PROCEDURE public.update_account_balance(IN p_account_id integer, IN inp_new_balance numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Account Types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Account Types" (
    id integer NOT NULL,
    description character(50)
);

ALTER TABLE ONLY public."Account Types" FORCE ROW LEVEL SECURITY;


ALTER TABLE public."Account Types" OWNER TO postgres;

--
-- Name: Account Types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Account Types_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Account Types_id_seq" OWNER TO postgres;

--
-- Name: Account Types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Account Types_id_seq" OWNED BY public."Account Types".id;


--
-- Name: Accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Accounts" (
    id integer NOT NULL,
    customer_id integer,
    "openingDate" date,
    balance numeric,
    type_id integer
);

ALTER TABLE ONLY public."Accounts" FORCE ROW LEVEL SECURITY;


ALTER TABLE public."Accounts" OWNER TO postgres;

--
-- Name: Accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Accounts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Accounts_id_seq" OWNER TO postgres;

--
-- Name: Accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Accounts_id_seq" OWNED BY public."Accounts".id;


--
-- Name: Customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Customers" (
    id integer NOT NULL,
    login character(20) NOT NULL,
    "passHash" character(40) NOT NULL,
    name character(20) NOT NULL,
    phone character(20) NOT NULL,
    email character(50) NOT NULL,
    "registrationDate" date NOT NULL
);

ALTER TABLE ONLY public."Customers" FORCE ROW LEVEL SECURITY;


ALTER TABLE public."Customers" OWNER TO postgres;

--
-- Name: Customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Customers_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Customers_id_seq" OWNER TO postgres;

--
-- Name: Customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Customers_id_seq" OWNED BY public."Customers".id;


--
-- Name: Loan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Loan" (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    type_id integer NOT NULL,
    amount numeric NOT NULL
);

ALTER TABLE ONLY public."Loan" FORCE ROW LEVEL SECURITY;


ALTER TABLE public."Loan" OWNER TO postgres;

--
-- Name: Loan Types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Loan Types" (
    id integer NOT NULL,
    description character(100) NOT NULL
);


ALTER TABLE public."Loan Types" OWNER TO postgres;

--
-- Name: Loan Types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Loan Types_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Loan Types_id_seq" OWNER TO postgres;

--
-- Name: Loan Types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Loan Types_id_seq" OWNED BY public."Loan Types".id;


--
-- Name: Loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Loan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Loan_id_seq" OWNER TO postgres;

--
-- Name: Loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Loan_id_seq" OWNED BY public."Loan".id;


--
-- Name: Transaction type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transaction type" (
    id integer NOT NULL,
    description character(50) NOT NULL
);

ALTER TABLE ONLY public."Transaction type" FORCE ROW LEVEL SECURITY;


ALTER TABLE public."Transaction type" OWNER TO postgres;

--
-- Name: Transaction type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Transaction type_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Transaction type_id_seq" OWNER TO postgres;

--
-- Name: Transaction type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Transaction type_id_seq" OWNED BY public."Transaction type".id;


--
-- Name: Transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transactions" (
    id integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    amount numeric NOT NULL,
    account_id integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public."Transactions" OWNER TO postgres;

--
-- Name: Transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Transactions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Transactions_id_seq" OWNER TO postgres;

--
-- Name: Transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Transactions_id_seq" OWNED BY public."Transactions".id;


--
-- Name: customer_account_balance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_account_balance AS
 SELECT "Customers".name,
    "Accounts".id,
    "Accounts".balance
   FROM (public."Customers"
     JOIN public."Accounts" ON (("Customers".id = "Accounts".customer_id)));


ALTER TABLE public.customer_account_balance OWNER TO postgres;

--
-- Name: customer_account_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_account_count AS
 SELECT "Customers".id,
    "Customers".name,
    count("Accounts".id) AS "Number of Accounts"
   FROM (public."Customers"
     LEFT JOIN public."Accounts" ON (("Customers".id = "Accounts".customer_id)))
  GROUP BY "Customers".id, "Customers".name;


ALTER TABLE public.customer_account_count OWNER TO postgres;

--
-- Name: transaction_type_description; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.transaction_type_description AS
 SELECT "Transactions".id,
    "Transactions".datetime,
    "Transactions".amount,
    "Transaction type".description AS "Transaction Type Description"
   FROM (public."Transactions"
     JOIN public."Transaction type" ON (("Transactions".type_id = "Transaction type".id)));


ALTER TABLE public.transaction_type_description OWNER TO postgres;

--
-- Name: Account Types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account Types" ALTER COLUMN id SET DEFAULT nextval('public."Account Types_id_seq"'::regclass);


--
-- Name: Accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Accounts" ALTER COLUMN id SET DEFAULT nextval('public."Accounts_id_seq"'::regclass);


--
-- Name: Customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customers" ALTER COLUMN id SET DEFAULT nextval('public."Customers_id_seq"'::regclass);


--
-- Name: Loan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan" ALTER COLUMN id SET DEFAULT nextval('public."Loan_id_seq"'::regclass);


--
-- Name: Loan Types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan Types" ALTER COLUMN id SET DEFAULT nextval('public."Loan Types_id_seq"'::regclass);


--
-- Name: Transaction type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction type" ALTER COLUMN id SET DEFAULT nextval('public."Transaction type_id_seq"'::regclass);


--
-- Name: Transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions" ALTER COLUMN id SET DEFAULT nextval('public."Transactions_id_seq"'::regclass);


--
-- Data for Name: Account Types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Account Types" (id, description) FROM stdin;
1	test                                              
2	test2                                             
\.


--
-- Data for Name: Accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Accounts" (id, customer_id, "openingDate", balance, type_id) FROM stdin;
1	1	2023-04-02	200	1
2	2	2023-04-02	2400.12	1
\.


--
-- Data for Name: Customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Customers" (id, login, "passHash", name, phone, email, "registrationDate") FROM stdin;
1	TestLogin           	TestPass                                	TestName            	TestPhone           	TestEmail                                         	2023-04-02
2	TestLogin           	TestPass                                	TestName            	TestPhone           	TestEmail                                         	2023-04-02
\.


--
-- Data for Name: Loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Loan" (id, customer_id, type_id, amount) FROM stdin;
1	1	1	10.2
2	2	1	20.9
3	2	2	100
\.


--
-- Data for Name: Loan Types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Loan Types" (id, description) FROM stdin;
1	test1                                                                                               
2	test2                                                                                               
\.


--
-- Data for Name: Transaction type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transaction type" (id, description) FROM stdin;
1	test                                              
2	test2                                             
\.


--
-- Data for Name: Transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transactions" (id, datetime, amount, account_id, type_id) FROM stdin;
\.


--
-- Name: Account Types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Account Types_id_seq"', 2, true);


--
-- Name: Accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Accounts_id_seq"', 2, true);


--
-- Name: Customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Customers_id_seq"', 2, true);


--
-- Name: Loan Types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Loan Types_id_seq"', 2, true);


--
-- Name: Loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Loan_id_seq"', 3, true);


--
-- Name: Transaction type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Transaction type_id_seq"', 2, true);


--
-- Name: Transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Transactions_id_seq"', 1, false);


--
-- Name: Account Types Account Types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account Types"
    ADD CONSTRAINT "Account Types_pkey" PRIMARY KEY (id);


--
-- Name: Accounts Accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Accounts"
    ADD CONSTRAINT "Accounts_pkey" PRIMARY KEY (id);


--
-- Name: Customers Customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customers"
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY (id);


--
-- Name: Loan Types Loan Types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan Types"
    ADD CONSTRAINT "Loan Types_pkey" PRIMARY KEY (id);


--
-- Name: Loan Loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan"
    ADD CONSTRAINT "Loan_pkey" PRIMARY KEY (id);


--
-- Name: Transaction type Transaction type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction type"
    ADD CONSTRAINT "Transaction type_pkey" PRIMARY KEY (id);


--
-- Name: Transactions Transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Transactions_pkey" PRIMARY KEY (id);


--
-- Name: Accounts Accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Accounts"
    ADD CONSTRAINT "Accounts_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public."Customers"(id) NOT VALID;


--
-- Name: Accounts Accounts_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Accounts"
    ADD CONSTRAINT "Accounts_type_id_fkey" FOREIGN KEY (type_id) REFERENCES public."Account Types"(id) NOT VALID;


--
-- Name: Loan Loan_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan"
    ADD CONSTRAINT "Loan_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public."Customers"(id) NOT VALID;


--
-- Name: Loan Loan_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan"
    ADD CONSTRAINT "Loan_type_id_fkey" FOREIGN KEY (type_id) REFERENCES public."Loan Types"(id) NOT VALID;


--
-- Name: Transactions Transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Transactions_account_id_fkey" FOREIGN KEY (account_id) REFERENCES public."Accounts"(id) NOT VALID;


--
-- Name: Transactions Transactions_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Transactions_type_id_fkey" FOREIGN KEY (type_id) REFERENCES public."Transaction type"(id) NOT VALID;


--
-- Name: Account Types; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Account Types" ENABLE ROW LEVEL SECURITY;

--
-- Name: Accounts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Accounts" ENABLE ROW LEVEL SECURITY;

--
-- Name: Customers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Customers" ENABLE ROW LEVEL SECURITY;

--
-- Name: Loan; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Loan" ENABLE ROW LEVEL SECURITY;

--
-- Name: Transaction type; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Transaction type" ENABLE ROW LEVEL SECURITY;

--
-- Name: Accounts manager_account_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manager_account_policy ON public."Accounts" TO manager USING (true);


--
-- Name: Account Types manager_at_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manager_at_policy ON public."Account Types" TO manager USING (true);


--
-- Name: Customers manager_customer_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manager_customer_policy ON public."Customers" TO manager USING (true);


--
-- Name: Loan manager_loan_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manager_loan_policy ON public."Loan" TO manager USING (true);


--
-- Name: Transaction type manager_tt_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manager_tt_policy ON public."Transaction type" TO manager USING (true);


--
-- Name: Accounts user_auditor_account_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_auditor_account_policy ON public."Accounts" TO role_user, auditor USING (true);


--
-- Name: Account Types user_auditor_at_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_auditor_at_policy ON public."Account Types" TO role_user, auditor USING (true);


--
-- Name: Customers user_auditor_customer_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_auditor_customer_policy ON public."Customers" TO role_user, auditor USING (true);


--
-- Name: Loan user_auditor_loan_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_auditor_loan_policy ON public."Loan" TO role_user, auditor USING (true);


--
-- Name: Transaction type user_auditor_tt_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_auditor_tt_policy ON public."Transaction type" TO role_user, auditor USING (true);


--
-- PostgreSQL database dump complete
--

