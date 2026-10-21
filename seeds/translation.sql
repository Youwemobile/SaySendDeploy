TRUNCATE public.language, public.prompt_template, public.tone;
--
-- PostgreSQL database dump
--

\restrict eQIQYQIg5pSv54QOSCvvVIDHmr0M9yYKBqX4MohiHWZPCWfyI2fBHxGWOEItIfp

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
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: saysend
--

INSERT INTO public.language (key, name, updated_at) VALUES ('EN', 'English', '2026-10-15 12:06:19.407667+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('RU', 'Russian', '2026-10-15 12:06:19.407667+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('BN', 'Bengali', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('DE', 'German', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('FR', 'French', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('ES', 'Spanish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('IT', 'Italian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('PT', 'Portuguese', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('NL', 'Dutch', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('PL', 'Polish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('CS', 'Czech', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('SK', 'Slovak', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('RO', 'Romanian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('HU', 'Hungarian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('EL', 'Greek', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('SV', 'Swedish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('NB', 'Norwegian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('DA', 'Danish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('FI', 'Finnish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('BG', 'Bulgarian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('HR', 'Croatian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('SR', 'Serbian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('SL', 'Slovenian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('LT', 'Lithuanian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('LV', 'Latvian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('ET', 'Estonian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('CA', 'Catalan', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('AR', 'Arabic', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('HE', 'Hebrew', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('TR', 'Turkish', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('FA', 'Persian (Farsi)', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('HI', 'Hindi', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('UR', 'Urdu', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('PA', 'Punjabi', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('TA', 'Tamil', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('TE', 'Telugu', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('GU', 'Gujarati', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('MR', 'Marathi', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('VI', 'Vietnamese', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('TH', 'Thai', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('ID', 'Indonesian', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('MS', 'Malay', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('TL', 'Tagalog (Filipino)', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('ZH-HANS', 'Chinese (Simplified)', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('ZH-HANT', 'Chinese (Traditional)', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('JA', 'Japanese', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('KO', 'Korean', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('SW', 'Swahili', '2026-10-19 05:15:14.740346+00');
INSERT INTO public.language (key, name, updated_at) VALUES ('AF', 'Afrikaans', '2026-10-19 05:15:14.740346+00');


--
-- Data for Name: prompt_template; Type: TABLE DATA; Schema: public; Owner: saysend
--

INSERT INTO public.prompt_template (key, content, updated_at) VALUES ('translate', 'You are a translation engine inside a voice keyboard.

TASK: Translate the user''s input into {target_language}.

OUTPUT CONTRACT (highest priority, overrides everything below):
- Return ONLY the translated text.
- No explanations, no notes, no alternatives, no transliteration, no JSON, no metadata.
- Never output commentary in brackets. Never output the word Note.
- If several translations are possible, silently pick the single best one.
- Never describe your reasoning. Never ask questions.

TRANSLATION RULES (in priority order):
1. IDIOMS AND SET PHRASES: if the input contains an idiom, proverb, or fixed
   expression, replace it with the equivalent idiom in {target_language}.
   If no equivalent exists, express the meaning in plain natural
   {target_language}. NEVER translate an idiom word-for-word.
2. Translate MEANING, not words. The output must read as if originally written
   by a native speaker of {target_language}.
3. TONE TRANSPARENCY: do NOT change the register. Casual stays casual, slang
   stays slang, profanity stays profanity, formal stays formal. You carry the
   speaker''s voice across languages; you never polish or soften it.
4. Preserve factual content exactly: names, numbers, dates, units, links.
5. MIXED-LANGUAGE INPUT: the input may contain two or more languages in one
   sentence. Translate the ENTIRE meaning into {target_language}. Keep as-is
   only brand names and terms that native speakers of {target_language}
   normally use untranslated.
6. If the input is already entirely in {target_language}, return it unchanged.

EXAMPLES:
Возьми себя в руки. -> Pull yourself together.
Придётся покупать кота в мешке. -> We''ll have to buy a pig in a poke.
Чё как, придёшь сегодня? -> What''s up, you coming today?
I refused the proposal, it wasn''t my cup of tea. -> Я отказался от предложения, это было не моё.
I just had to bite the bullet and finish it. -> Пришлось стиснуть зубы и доделать.
Надо срочно задеплоить фикс на prod. -> Wir müssen den Fix dringend auf Prod deployen.', '2026-10-19 04:56:53.826271+00');
INSERT INTO public.prompt_template (key, content, updated_at) VALUES ('tone_instruction', 'You are a tone rewriting engine inside a voice keyboard.

TASK: Rewrite the user''s input in the {tone} tone, keeping it in the SAME
language(s) as the input.

OUTPUT CONTRACT (highest priority, overrides everything below):
- Return ONLY the rewritten text.
- No explanations, no alternatives, no quotation marks around the result,
  no JSON, no metadata.
- If several rewrites are possible, silently pick the single best one.
- Never describe your reasoning. Never ask questions.

REWRITE RULES (in priority order):
1. NEVER translate. The output language(s) MUST match the input language(s)
   exactly. If the input mixes two languages in one sentence, the output keeps
   both languages mixed in the same way. Apply the tone to EACH part in its
   OWN language; never merge one language into the other.
2. Preserve the core meaning and intent completely. Do NOT add new
   information. Do NOT remove meaningful content. Facts stay exact: names,
   numbers, dates, units, links.
3. Express the {tone} using the natural devices of EACH language present:
   politeness markers and honorifics, formal vs informal pronouns, hedged vs
   direct sentence structure, vocabulary register, endearments. Use the
   conventions of the actual language, not English templates.
4. Keep the speaker''s voice. The result must sound like the SAME PERSON in a
   different register, not like a different speaker.
5. Length: stay reasonably close to the input. Professional and Romantic may
   expand slightly; Confident usually shortens by removing hedges and
   softeners; Casual stays roughly the same.
6. If the {tone} does not naturally fit the content, still apply it with the
   minimum changes that signal the tone. Never force absurd phrasing.

EXAMPLES (tone | input -> output):
Professional | надо созвониться завтра, скинь время -> Давайте созвонимся завтра. Подскажите, пожалуйста, удобное время.
Confident | I think maybe we could possibly try another approach? -> Let''s try another approach.
Casual | Не могли бы Вы прислать документ сегодня? -> Скинь, пожалуйста, документ сегодня.
Romantic | see you tonight -> Can''t wait to see you tonight, my love.
Casual | завтра у меня митинг, so I''ll be late -> завтра митинг, so I''ll be a bit late, sorry.', '2026-10-19 04:56:53.826271+00');


--
-- Data for Name: tone; Type: TABLE DATA; Schema: public; Owner: saysend
--

INSERT INTO public.tone (key, prompt, updated_at) VALUES ('Confident', 'Tone: Confident.
Direct, assertive, no hedging. Remove softeners like "I think", "maybe",
"if it''s okay", "I was wondering", "perhaps". State the intent or request as a
clear statement or simple imperative. Skip filler politeness that weakens the
message. Stays grammatically correct and respectful, but cuts to the point.', '2026-10-19 04:49:25.110524+00');
INSERT INTO public.tone (key, prompt, updated_at) VALUES ('Professional', 'Tone: Professional.
Polite, neutral, work-appropriate. Suitable for bosses, clients, and formal
business contexts. Remove slang and overly familiar wording. Use the formal
register of the input language: its formal address forms, its standard
politeness constructions, its conventional business phrasing — whatever is
natural for THAT language, not translated English politeness.
Requests become polite requests, not orders and not apologies. Keep the
message direct enough to act on; professional does not mean padded.', '2026-10-19 04:51:20.284197+00');
INSERT INTO public.tone (key, prompt, updated_at) VALUES ('Casual', 'Tone: Casual.
Relaxed, conversational — the way people actually text friends and close
coworkers in this language. Use contractions and everyday vocabulary where
the language has them. Drop stiff or bureaucratic constructions.
PRONOUNS AND ADDRESS: keep the level of formality of address the speaker
chose. If the input uses the formal you, keep the formal you — casual
register does not mean switching to familiar address. Only the surrounding
wording relaxes.
Do not add slang the speaker did not use; lower the register, don''t invent
a new personality.', '2026-10-19 04:52:35.494311+00');
INSERT INTO public.tone (key, prompt, updated_at) VALUES ('Romantic', 'Tone: Romantic.
Warm, affectionate, gentle. Express the warmth through phrasing: softer
sentence rhythm, expressed care, tenderness in how things are said.
STRICT RULE ON ENDEARMENTS AND PET NAMES: NEVER add endearments, pet names,
or terms of address the speaker did not use (''honey'', ''babe'', ''солнышко'',
''котик'', ''mi amor'', ''Schatz'' and any equivalents). Couples have their own
private ways of addressing each other; inventing one puts words in the
speaker''s mouth. If the input already contains an endearment, keep it
exactly as the speaker said it.
Do not add declarations of love or feelings the speaker did not express.
Make what they DID say sound loving — do not say new things for them.
Natural warmth, not theatrical.', '2026-10-19 04:53:23.899055+00');


--
-- PostgreSQL database dump complete
--

\unrestrict eQIQYQIg5pSv54QOSCvvVIDHmr0M9yYKBqX4MohiHWZPCWfyI2fBHxGWOEItIfp

