TRUNCATE public.document_version;
--
-- PostgreSQL database dump
--

\restrict ZM6x7uCcc4EzPdtQjFAeUMMalLfxpB02X8ZyFhvRNR1PhoTaU77gczN2nvKYPfs

-- Dumped from database version 17.11
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: document_version; Type: TABLE DATA; Schema: public; Owner: saysend
--

INSERT INTO public.document_version (doc_type, version, updated_at) VALUES ('tos', '1', '2026-10-19 08:24:51.669993+00');
INSERT INTO public.document_version (doc_type, version, updated_at) VALUES ('privacy', '1', '2026-10-19 08:24:57.65551+00');


--
-- PostgreSQL database dump complete
--

\unrestrict ZM6x7uCcc4EzPdtQjFAeUMMalLfxpB02X8ZyFhvRNR1PhoTaU77gczN2nvKYPfs

