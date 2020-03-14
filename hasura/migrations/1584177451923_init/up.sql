CREATE TABLE public.comment (
    id integer NOT NULL,
    text text NOT NULL,
    article_id integer NOT NULL,
    commenter_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE FUNCTION public.get_spam_count(comment_row public.comment) RETURNS bigint
    LANGUAGE sql STABLE
    AS $$
  SELECT count(*)
  FROM comment_spam
  WHERE comment_id = comment_row.id
$$;
CREATE TABLE public.article (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    author_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.article_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.article_id_seq OWNED BY public.article.id;
CREATE SEQUENCE public.comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.comment_id_seq OWNED BY public.comment.id;
CREATE TABLE public.comment_spam (
    comment_id integer NOT NULL,
    user_id text NOT NULL
);
CREATE TABLE public."user" (
    id text NOT NULL,
    username text NOT NULL,
    age integer NOT NULL,
    avatar text NOT NULL
);
ALTER TABLE ONLY public.article ALTER COLUMN id SET DEFAULT nextval('public.article_id_seq'::regclass);
ALTER TABLE ONLY public.comment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);
ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.comment_spam
    ADD CONSTRAINT comment_spam_pkey PRIMARY KEY (comment_id, user_id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_author_id_fkey FOREIGN KEY (author_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.article(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_commenter_id_fkey FOREIGN KEY (commenter_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.comment_spam
    ADD CONSTRAINT comment_spam_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comment(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.comment_spam
    ADD CONSTRAINT comment_spam_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
