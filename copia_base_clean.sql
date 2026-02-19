--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6 (Debian 17.6-0+deb13u1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-0+deb13u1)

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
-- Name: gestion_perfumance; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA gestion_perfumance;


ALTER SCHEMA gestion_perfumance OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actividad; Type: TABLE; Schema: gestion_perfumance; Owner: admin_perfumance
--

CREATE TABLE gestion_perfumance.actividad (
    id_actividad integer NOT NULL,
    id_usuario integer,
    descripcion text NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE gestion_perfumance.actividad OWNER TO admin_perfumance;

--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin_perfumance
--

CREATE SEQUENCE gestion_perfumance.actividad_id_actividad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.actividad_id_actividad_seq OWNER TO admin_perfumance;

--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER SEQUENCE gestion_perfumance.actividad_id_actividad_seq OWNED BY gestion_perfumance.actividad.id_actividad;


--
-- Name: cliente; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.cliente (
    id_cliente integer NOT NULL,
    nombres character varying(50) NOT NULL,
    apellidos character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100)
);


ALTER TABLE gestion_perfumance.cliente OWNER TO admin;

--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.cliente_id_cliente_seq OWNER TO admin;

--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.cliente_id_cliente_seq OWNED BY gestion_perfumance.cliente.id_cliente;


--
-- Name: compra; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.compra (
    id_compra integer NOT NULL,
    fecha_compra timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    costo_total numeric(10,2) NOT NULL,
    id_proveedor integer NOT NULL
);


ALTER TABLE gestion_perfumance.compra OWNER TO admin;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.compra_id_compra_seq OWNER TO admin;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.compra_id_compra_seq OWNED BY gestion_perfumance.compra.id_compra;


--
-- Name: detalle_compra; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.detalle_compra (
    id_detalle_compra integer NOT NULL,
    id_compra integer NOT NULL,
    id_perfume integer NOT NULL,
    cantidad integer NOT NULL,
    costo_unitario numeric(10,2) NOT NULL
);


ALTER TABLE gestion_perfumance.detalle_compra OWNER TO admin;

--
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.detalle_compra_id_detalle_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.detalle_compra_id_detalle_compra_seq OWNER TO admin;

--
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.detalle_compra_id_detalle_compra_seq OWNED BY gestion_perfumance.detalle_compra.id_detalle_compra;


--
-- Name: detalle_pago; Type: TABLE; Schema: gestion_perfumance; Owner: admin_perfumance
--

CREATE TABLE gestion_perfumance.detalle_pago (
    id_detalle_pago integer NOT NULL,
    id_pago integer NOT NULL,
    id_venta integer NOT NULL,
    id_cliente integer NOT NULL,
    id_perfume integer NOT NULL,
    cantidad integer NOT NULL,
    costo_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) GENERATED ALWAYS AS (((cantidad)::numeric * costo_unitario)) STORED
);


ALTER TABLE gestion_perfumance.detalle_pago OWNER TO admin_perfumance;

--
-- Name: detalle_pago_id_detalle_pago_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin_perfumance
--

CREATE SEQUENCE gestion_perfumance.detalle_pago_id_detalle_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.detalle_pago_id_detalle_pago_seq OWNER TO admin_perfumance;

--
-- Name: detalle_pago_id_detalle_pago_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER SEQUENCE gestion_perfumance.detalle_pago_id_detalle_pago_seq OWNED BY gestion_perfumance.detalle_pago.id_detalle_pago;


--
-- Name: detalle_venta; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.detalle_venta (
    id_detalle_venta integer NOT NULL,
    id_venta integer NOT NULL,
    id_perfume integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL
);


ALTER TABLE gestion_perfumance.detalle_venta OWNER TO admin;

--
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.detalle_venta_id_detalle_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.detalle_venta_id_detalle_venta_seq OWNER TO admin;

--
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.detalle_venta_id_detalle_venta_seq OWNED BY gestion_perfumance.detalle_venta.id_detalle_venta;


--
-- Name: direccion; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.direccion (
    id_direccion integer NOT NULL,
    id_usuario integer NOT NULL,
    nombre character varying(100) NOT NULL,
    calle character varying(255) NOT NULL,
    numero character varying(50) NOT NULL,
    departamento character varying(50),
    ciudad character varying(100) NOT NULL,
    estado character varying(100) NOT NULL,
    codigo_postal character varying(20) NOT NULL,
    telefono character varying(20),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE gestion_perfumance.direccion OWNER TO admin;

--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.direccion_id_direccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.direccion_id_direccion_seq OWNER TO admin;

--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.direccion_id_direccion_seq OWNED BY gestion_perfumance.direccion.id_direccion;


--
-- Name: empleado; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.empleado (
    id_empleado integer NOT NULL,
    nombres character varying(50) NOT NULL,
    apellidos character varying(50) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    id_rol integer
);


ALTER TABLE gestion_perfumance.empleado OWNER TO admin;

--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.empleado_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.empleado_id_empleado_seq OWNER TO admin;

--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.empleado_id_empleado_seq OWNED BY gestion_perfumance.empleado.id_empleado;


--
-- Name: genero; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.genero (
    id_genero integer NOT NULL,
    descripcion character varying(30) NOT NULL
);


ALTER TABLE gestion_perfumance.genero OWNER TO admin;

--
-- Name: genero_id_genero_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.genero_id_genero_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.genero_id_genero_seq OWNER TO admin;

--
-- Name: genero_id_genero_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.genero_id_genero_seq OWNED BY gestion_perfumance.genero.id_genero;


--
-- Name: pago; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.pago (
    id_pago integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total numeric(10,2) NOT NULL,
    estado character varying(30) DEFAULT 'Completado'::character varying,
    metododepago character varying(30) NOT NULL
);


ALTER TABLE gestion_perfumance.pago OWNER TO admin;

--
-- Name: pago_id_pago_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.pago_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.pago_id_pago_seq OWNER TO admin;

--
-- Name: pago_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.pago_id_pago_seq OWNED BY gestion_perfumance.pago.id_pago;


--
-- Name: perfume; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.perfume (
    id_perfume integer NOT NULL,
    marca character varying(50) NOT NULL,
    presentacion character varying(50),
    talla character varying(20),
    id_genero integer NOT NULL,
    stock integer DEFAULT 0,
    fecha_caducidad date,
    precio numeric(10,2),
    imagen character varying(255)
);


ALTER TABLE gestion_perfumance.perfume OWNER TO admin;

--
-- Name: perfume_id_perfume_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.perfume_id_perfume_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.perfume_id_perfume_seq OWNER TO admin;

--
-- Name: perfume_id_perfume_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.perfume_id_perfume_seq OWNED BY gestion_perfumance.perfume.id_perfume;


--
-- Name: proveedor; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.proveedor (
    id_proveedor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    direccion character varying(200),
    condiciones_comerciales text
);


ALTER TABLE gestion_perfumance.proveedor OWNER TO admin;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.proveedor_id_proveedor_seq OWNER TO admin;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.proveedor_id_proveedor_seq OWNED BY gestion_perfumance.proveedor.id_proveedor;


--
-- Name: rol; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.rol (
    id_rol integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE gestion_perfumance.rol OWNER TO admin;

--
-- Name: rol_id_rol_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.rol_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.rol_id_rol_seq OWNER TO admin;

--
-- Name: rol_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.rol_id_rol_seq OWNED BY gestion_perfumance.rol.id_rol;


--
-- Name: usuario; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.usuario (
    id_usuario integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(200) NOT NULL,
    email character varying(100),
    id_rol integer NOT NULL,
    activo boolean DEFAULT true,
    id_cliente integer,
    id_empleado integer
);


ALTER TABLE gestion_perfumance.usuario OWNER TO admin;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.usuario_id_usuario_seq OWNER TO admin;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.usuario_id_usuario_seq OWNED BY gestion_perfumance.usuario.id_usuario;


--
-- Name: venta; Type: TABLE; Schema: gestion_perfumance; Owner: admin
--

CREATE TABLE gestion_perfumance.venta (
    id_venta integer NOT NULL,
    fecha_venta timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    monto_total numeric(10,2) NOT NULL,
    id_cliente integer NOT NULL,
    id_empleado integer
);


ALTER TABLE gestion_perfumance.venta OWNER TO admin;

--
-- Name: venta_id_venta_seq; Type: SEQUENCE; Schema: gestion_perfumance; Owner: admin
--

CREATE SEQUENCE gestion_perfumance.venta_id_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_perfumance.venta_id_venta_seq OWNER TO admin;

--
-- Name: venta_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: gestion_perfumance; Owner: admin
--

ALTER SEQUENCE gestion_perfumance.venta_id_venta_seq OWNED BY gestion_perfumance.venta.id_venta;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO admin;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO admin;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO admin;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO admin;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO admin;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO admin;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO admin;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO admin;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO admin;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO admin;

--
-- Name: pfm_attribute; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_attribute (
    attribute text NOT NULL,
    typeofattrib text,
    typeofget text,
    sqlselect text,
    nr integer,
    form text NOT NULL,
    valuelist text,
    "default" text
);


ALTER TABLE public.pfm_attribute OWNER TO admin_perfumance;

--
-- Name: pfm_form; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_form (
    name text NOT NULL,
    tablename text,
    showform boolean DEFAULT true,
    view boolean DEFAULT false,
    sqlselect text,
    sqlfrom text,
    groupby text,
    help text,
    pkey text,
    sqlorderby text,
    sqllimit text
);


ALTER TABLE public.pfm_form OWNER TO admin_perfumance;

--
-- Name: pfm_link; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_link (
    linkname text NOT NULL,
    sqlwhere text,
    orderby text,
    displayattrib text,
    fromform text NOT NULL,
    toform text
);


ALTER TABLE public.pfm_link OWNER TO admin_perfumance;

--
-- Name: pfm_report; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_report (
    name text NOT NULL,
    description text,
    sqlselect text
);


ALTER TABLE public.pfm_report OWNER TO admin_perfumance;

--
-- Name: pfm_section; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_section (
    report text NOT NULL,
    level integer NOT NULL,
    fieldlist text,
    layout text,
    summary text,
    CONSTRAINT level_min_1 CHECK ((level >= 1))
);


ALTER TABLE public.pfm_section OWNER TO admin_perfumance;

--
-- Name: pfm_value; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_value (
    value text NOT NULL,
    description text,
    valuelist text NOT NULL
);


ALTER TABLE public.pfm_value OWNER TO admin_perfumance;

--
-- Name: pfm_value_list; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_value_list (
    name text NOT NULL
);


ALTER TABLE public.pfm_value_list OWNER TO admin_perfumance;

--
-- Name: pfm_version; Type: TABLE; Schema: public; Owner: admin_perfumance
--

CREATE TABLE public.pfm_version (
    seqnr integer NOT NULL,
    version text,
    date date,
    comment text
);


ALTER TABLE public.pfm_version OWNER TO admin_perfumance;

--
-- Name: pfm_version_seqnr_seq; Type: SEQUENCE; Schema: public; Owner: admin_perfumance
--

CREATE SEQUENCE public.pfm_version_seqnr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pfm_version_seqnr_seq OWNER TO admin_perfumance;

--
-- Name: pfm_version_seqnr_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin_perfumance
--

ALTER SEQUENCE public.pfm_version_seqnr_seq OWNED BY public.pfm_version.seqnr;


--
-- Name: actividad id_actividad; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.actividad ALTER COLUMN id_actividad SET DEFAULT nextval('gestion_perfumance.actividad_id_actividad_seq'::regclass);


--
-- Name: cliente id_cliente; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.cliente ALTER COLUMN id_cliente SET DEFAULT nextval('gestion_perfumance.cliente_id_cliente_seq'::regclass);


--
-- Name: compra id_compra; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.compra ALTER COLUMN id_compra SET DEFAULT nextval('gestion_perfumance.compra_id_compra_seq'::regclass);


--
-- Name: detalle_compra id_detalle_compra; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_compra ALTER COLUMN id_detalle_compra SET DEFAULT nextval('gestion_perfumance.detalle_compra_id_detalle_compra_seq'::regclass);


--
-- Name: detalle_pago id_detalle_pago; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago ALTER COLUMN id_detalle_pago SET DEFAULT nextval('gestion_perfumance.detalle_pago_id_detalle_pago_seq'::regclass);


--
-- Name: detalle_venta id_detalle_venta; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_venta ALTER COLUMN id_detalle_venta SET DEFAULT nextval('gestion_perfumance.detalle_venta_id_detalle_venta_seq'::regclass);


--
-- Name: direccion id_direccion; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.direccion ALTER COLUMN id_direccion SET DEFAULT nextval('gestion_perfumance.direccion_id_direccion_seq'::regclass);


--
-- Name: empleado id_empleado; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.empleado ALTER COLUMN id_empleado SET DEFAULT nextval('gestion_perfumance.empleado_id_empleado_seq'::regclass);


--
-- Name: genero id_genero; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.genero ALTER COLUMN id_genero SET DEFAULT nextval('gestion_perfumance.genero_id_genero_seq'::regclass);


--
-- Name: pago id_pago; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.pago ALTER COLUMN id_pago SET DEFAULT nextval('gestion_perfumance.pago_id_pago_seq'::regclass);


--
-- Name: perfume id_perfume; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.perfume ALTER COLUMN id_perfume SET DEFAULT nextval('gestion_perfumance.perfume_id_perfume_seq'::regclass);


--
-- Name: proveedor id_proveedor; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('gestion_perfumance.proveedor_id_proveedor_seq'::regclass);


--
-- Name: rol id_rol; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.rol ALTER COLUMN id_rol SET DEFAULT nextval('gestion_perfumance.rol_id_rol_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('gestion_perfumance.usuario_id_usuario_seq'::regclass);


--
-- Name: venta id_venta; Type: DEFAULT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.venta ALTER COLUMN id_venta SET DEFAULT nextval('gestion_perfumance.venta_id_venta_seq'::regclass);


--
-- Name: pfm_version seqnr; Type: DEFAULT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_version ALTER COLUMN seqnr SET DEFAULT nextval('public.pfm_version_seqnr_seq'::regclass);


--
-- Data for Name: actividad; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin_perfumance
--

COPY gestion_perfumance.actividad (id_actividad, id_usuario, descripcion, fecha) FROM stdin;
1	1	Eliminó el usuario 'gale_goldenboy1'.	2025-12-07 17:22:41.737775
2	1	Eliminó el usuario 'Dav12'.	2025-12-07 17:22:44.075581
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.cliente (id_cliente, nombres, apellidos, telefono, email) FROM stdin;
1	Jose Alberto	Vazquez Lopez	5624127179	zefvalo.152020@gmail.com
2	David	Martinez Velasco	5573780905	davidm_2003@gmail.com
3	Geal	Pizaña	5567438902	geal_golde@gmail.com
4	Test	User	+525552206277	test@example.com
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.compra (id_compra, fecha_compra, costo_total, id_proveedor) FROM stdin;
\.


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.detalle_compra (id_detalle_compra, id_compra, id_perfume, cantidad, costo_unitario) FROM stdin;
\.


--
-- Data for Name: detalle_pago; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin_perfumance
--

COPY gestion_perfumance.detalle_pago (id_detalle_pago, id_pago, id_venta, id_cliente, id_perfume, cantidad, costo_unitario) FROM stdin;
\.


--
-- Data for Name: detalle_venta; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.detalle_venta (id_detalle_venta, id_venta, id_perfume, cantidad, precio_unitario) FROM stdin;
\.


--
-- Data for Name: direccion; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.direccion (id_direccion, id_usuario, nombre, calle, numero, departamento, ciudad, estado, codigo_postal, telefono, fecha_creacion) FROM stdin;
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.empleado (id_empleado, nombres, apellidos, telefono, email, id_rol) FROM stdin;
1	Diego	Grimaldo Osorio	5591007013	grimaldodiego380@gmail.com	1
\.


--
-- Data for Name: genero; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.genero (id_genero, descripcion) FROM stdin;
1	Hombre
2	Mujer
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.pago (id_pago, id_cliente, fecha_pago, total, estado, metododepago) FROM stdin;
\.


--
-- Data for Name: perfume; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.perfume (id_perfume, marca, presentacion, talla, id_genero, stock, fecha_caducidad, precio, imagen) FROM stdin;
1	Scandal	Eau de Parfum	100ml	2	10	2030-12-30	3320.00	\N
2	D&G Light Blue	Eau de Parfum	100ml	2	12	2030-12-31	3350.00	\N
3	Miss Dior	Eau de Parfum	100ml	2	8	2030-12-31	2400.00	\N
4	Coach for Men	Eau de Parfum	100ml	1	9	2030-12-31	3290.00	\N
5	Versace Eros	Eau de Toilette	100ml	1	11	2030-12-31	4300.00	\N
6	Acqua di Giò	Eau de Toilette	100ml	1	10	2030-12-31	2469.00	\N
7	Valentino Uomo	Eau de Parfum	100ml	1	7	2030-12-31	2548.00	\N
8	Dior Sauvage	Eau de Parfum	100ml	1	6	2030-12-31	5900.00	\N
9	Sensus In Black	Eau de Toilette	100ml	1	10	2030-12-31	382.00	\N
10	Black Opium	Eau de Parfum	100ml	2	12	2030-12-31	3800.00	\N
11	Coco Mademoiselle	Eau de Parfum	100ml	2	8	2030-12-31	3220.00	\N
12	Dior Sauvage	Parfum	100ml	1	10	2030-12-31	3831.00	\N
13	Hugo Boss The Scent	Eau de Parfum	100ml	2	11	2030-12-31	1620.00	\N
14	Gaultier Divine	Eau de Parfum	100ml	2	10	2030-12-31	3300.00	\N
15	L BEL Fleur	Eau de Parfum	50ml	2	12	2030-12-31	760.00	\N
16	Moschino Toy Boy	Eau de Parfum	100ml	1	11	2030-12-31	1800.00	\N
17	1 Million de Paco Rabanne	Eau de Toilette	100ml	1	13	2030-12-31	2299.00	\N
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.proveedor (id_proveedor, nombre, telefono, email, direccion, condiciones_comerciales) FROM stdin;
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.rol (id_rol, descripcion) FROM stdin;
1	Gerente
2	Empleado
3	Cliente
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.usuario (id_usuario, username, password, email, id_rol, activo, id_cliente, id_empleado) FROM stdin;
1	Diego-Ghost	$argon2id$v=19$m=65536,t=3,p=4$xuhA7Yr5bPRfrnesVNT7kA$LURh4hcvDv0XG61jKyB/maHFAnWfbuvWiWTq+xAb7dI	grimaldodiego380@gmail.com	1	t	\N	1
2	JossWar	$argon2id$v=19$m=65536,t=3,p=4$DTtvVRv7CmiEfHfi9PY6dA$zGQwa4OSAqny9NjdqEtkk2gYZKCfAXFqPgmjjzpAoZM	zefvalo.152020@gmail.com	3	t	1	\N
5	test_user	pbkdf2_sha256$1200000$EbCjcwkeawQUawgCf8WJ8u$Ryp3hB18k3arQZAL2/Jd0vSofVFivQpfMxwYD7fdCWw=	test@example.com	1	t	4	\N
\.


--
-- Data for Name: venta; Type: TABLE DATA; Schema: gestion_perfumance; Owner: admin
--

COPY gestion_perfumance.venta (id_venta, fecha_venta, monto_total, id_cliente, id_empleado) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-12-06 18:36:56.330221-06
2	auth	0001_initial	2025-12-06 18:36:56.390414-06
3	admin	0001_initial	2025-12-06 18:36:56.412114-06
4	admin	0002_logentry_remove_auto_add	2025-12-06 18:36:56.425452-06
5	admin	0003_logentry_add_action_flag_choices	2025-12-06 18:36:56.436979-06
6	contenttypes	0002_remove_content_type_name	2025-12-06 18:36:56.456755-06
7	auth	0002_alter_permission_name_max_length	2025-12-06 18:36:56.467514-06
8	auth	0003_alter_user_email_max_length	2025-12-06 18:36:56.477029-06
9	auth	0004_alter_user_username_opts	2025-12-06 18:36:56.486986-06
10	auth	0005_alter_user_last_login_null	2025-12-06 18:36:56.496142-06
11	auth	0006_require_contenttypes_0002	2025-12-06 18:36:56.498382-06
12	auth	0007_alter_validators_add_error_messages	2025-12-06 18:36:56.507745-06
13	auth	0008_alter_user_username_max_length	2025-12-06 18:36:56.521377-06
14	auth	0009_alter_user_last_name_max_length	2025-12-06 18:36:56.530205-06
15	auth	0010_alter_group_name_max_length	2025-12-06 18:36:56.543512-06
16	auth	0011_update_proxy_permissions	2025-12-06 18:36:56.551896-06
17	auth	0012_alter_user_first_name_max_length	2025-12-06 18:36:56.562212-06
18	sessions	0001_initial	2025-12-06 18:36:56.573363-06
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
imqldtgrvdjzlwrw1h7z5vyj80mo0cyf	.eJw9zcEKwyAQBNB_mbPEpLn5Gz2WIlu1sqUa2aynkH-vlNLrzBvmQCAR1g3udoCjb0mevSS4xaCQBILDNVCN9IZBkxR42HW9zNNsxrgqR4pfvveHbjrcv-ZCOVXfZWSwu5JysFyy_b34ZXq1jPN-fgDRfSyL:1vSKJ4:64n9gePsYYJa1HqSUudmFq5icxVvEKXHy5VqBHDkyjk	2025-12-21 13:20:30.563553-06
4c96a9nmf3h3t5is8mue7ycja6nbdzhg	.eJw9zcEKwyAQBNB_mbPEpLn5Gz2WIlu1sqUa2aynkH-vlNLrzBvmQCAR1g3udoCjb0mevSS4xaCQBILDNVCN9IZBkxR42HW9zNNsxrgqR4pfvveHbjrcv-ZCOVXfZWSwu5JysFyy_b34ZXq1jPN-fgDRfSyL:1vSKJp:7foRx8ugZgSlfejoBa47dIxE699BebO04OvinQrFPQA	2025-12-21 13:21:17.203742-06
krqj78tbkboovv1mn17wdy8axoq80rpd	.eJxFjbEOwiAURX_F3JkUTO3C7i-4GEOegOQZKc0Dpqb_LoOJ6z055-7wJMKtwN53cHBblFfPEXZRyCSeYHGLUsnH01VKhcIm0fMQLrMxk1GjsDYOFGDPCrU_W2n0-WPOlOLquowNujZq7DXnpH9XbpneW8LxOL7JBi5d:1vSKjv:JFbs65rkGBVHTvDU_vH34LTHVwzfw-pzv6UZMYEtfnM	2025-12-21 13:48:15.391542-06
tt317op7uz955w5m9tvuinx8w5g40ep6	.eJwtjcEKAiEURX8l7lpGaWYRrtv2BRHyUpMXOQ5PXQ3z7wm1Pfdczg5PItwK7H0HB7dFefUcYWeFTOIJFjeu9XTlIlDYJHoe9nkxZjJq3NfGgcIgCrU_W2n0gV0uv5kzpbi6LoNB10aNveac9L_j5um9JRyP4wsmXC0m:1vSKmS:8jxKjmYF8yUPaj835uuFzOEMBTyYk1AmS533u_GxTNg	2025-12-21 13:50:52.051034-06
r0i3hmpndbfec62n7i2gaxhmu48be3wp	.eJyNzk0KgzAQBeCryKyDxsaFZFm6LT1AKTKNqUxrNEySlXj3Biz0Z9Xtmzd8bwGDzBRn0OcFqO-85VtyFrQS4JANgoYjhVAcaGYQ4Nkayu1dI2UpRX6fIvXY50RASNc4RxxBN-12JoeDnbrEOYMqRIxkKnJD9XI6Vd79AKv4xmv51vcjmkdx8pTch6_aX7_-9NW_fi23AZf1CRtLVnE:1vSKnz:yS19VYOXpVkYrp1MFqQA3Nvm_952FAV_dfdw1lLR36c	2025-12-21 13:52:27.999907-06
h18eg0vqke4hbr4ssfyvz4mogkwqvdw8	.eJw9zcEKwyAQBNB_mbPEpLn5Gz2WIlu1sqUa2aynkH-vlNLrzBvmQCAR1g3udoCjb0mevSS4xaCQBILDNVCN9IZBkxR42HW9zNNsxrgqR4pfvveHbjrcv-ZCOVXfZWSwu5JysFyy_b34ZXq1jPN-fgDRfSyL:1vSKv8:wIspK9x09_S_7xT3NGAdNvk8mbKw4cGZ9jtI-uipCHc	2025-12-21 13:59:50.024801-06
v04ljc3up6przo2l0dt3s8rjq56imi1f	.eJxFjUEKwjAURK8isw6NilLJPXRTJHyTGL40TfhNVqV3NwvB7Xu8mQ2ORLhmmGkDe1uCvFsKMKNCInEEgwfNYam85MM9pwyFIsFxT87Xy204qr7RtScPc1JY26vmSvNfc6IYFtukM-i1UmWnOUX9O7Pj8CkR-3P_AknJL2c:1vSL0t:AoQxLub_oLZrySr4v4v7ZPbq05LnswsexnGQN90Q9_0	2025-12-21 14:05:47.739294-06
z8w8cbb4blfbst2k7y9ru9i3fxapxlj7	.eJxFjUEKwjAURK8isw6NilLJPXRTJHyTGL40TfhNVqV3NwvB7Xu8mQ2ORLhmmGkDe1uCvFsKMKNCInEEgwfNYam85MM9pwyFIsFxT87Xy204qr7RtScPc1JY26vmSvNfc6IYFtukM-i1UmWnOUX9O7Pj8CkR-3P_AknJL2c:1vSL1U:nzboWf5xSenVyzM7VfZxyfMJF9BH8k5mGrUTyWicF7s	2025-12-21 14:06:24.632946-06
y3gvk7s29kh0ptx60cj0lala50w46343	.eJxFjbEKwjAURX-l3MEpNLXFJaMILv6BSHgmMT5p2pC-TKX_bgfB9R7OuSsclcIyw9xXsLc5lFdNAaZXSFQcweByuDY3jm9pzmMNUMglON6VYTh1baf2xiTsycMcFZb6lFlo_GNOFMNka9k36EVI2GlOUf_ObN9-csT22L7c6C5O:1vSL4W:ytqDtyD9lK-vj8DNn3BMbFzumFpLM2KRt0EBejaUrRE	2025-12-21 14:09:32.967243-06
tm7j6r3pw37edx9wc5j6ap74ph7vn2ky	.eJxFjbEKwjAURX-l3MEpNLXFJaMILv6BSHgmMT5p2pC-TKX_bgfB9R7OuSsclcIyw9xXsLc5lFdNAaZXSFQcweByuDY3jm9pzmMNUMglON6VYTh1baf2xiTsycMcFZb6lFlo_GNOFMNka9k36EVI2GlOUf_ObN9-csT22L7c6C5O:1vSL5W:A3_B5933NV6k6pMhnmDnMRBBSvBe3V-Ud5orz-fGNJo	2025-12-21 14:10:34.548821-06
tlhlel25sedqihcnzvqyebift67ypdxw	.eJyNzjELwjAQBeC_Um5wCm1srUhGUVycXUTKmcZ40rTlkkyl_92CQtXJ9R3vvjeARmYKHajzAFRXveFbdAZULsAhawQFu8UhOZK9h2TbRAMCejaapkpRlDKVYvrRBqqxBrUU4OM1dAGb-UwOrWmryFMGmQ8YSGfkbPbGqjx99BZG8b2gnBecDHvUJtlz5z_8VSF__PzT36zlf3758i_jEzJEV7w:1vSL64:P5h_tC9gblak493E-MW3mHjOCXs6Eolb4xptMVxAtb4	2025-12-21 14:11:08.036273-06
pa4nyor7mb2gpnotkb9bnsbb8r2u7mt7	eyJjYXJyaXRvIjpbXX0:1vSLGH:nduvds1Xbk4jVzgA870haQJuvzbrrbRQwFm6JmcWIRw	2025-12-21 14:21:41.640373-06
uvnqzqnvz7pew48xqwg0dys97zlh54qd	.eJw9zcEKwyAQBNB_mbPEpLn5Gz2WIlu1sqUa2aynkH-vlNLrzBvmQCAR1g3udoCjb0mevSS4xaCQBILDNVCN9IZBkxR42HW9zNNsxrgqR4pfvveHbjrcv-ZCOVXfZWSwu5JysFyy_b34ZXq1jPN-fgDRfSyL:1vSLGS:EQSUJ2zncr9VavSn1oDDT1u-iVq5sEMsV4oLXDjtZBE	2025-12-21 14:21:52.475105-06
04adcybzysrkjeny0xwwtf1xpm8v3xmn	eyJ1c3VhcmlvIjp7ImlkX3VzdWFyaW8iOjIsInVzZXJuYW1lIjoiSm9zc1dhciIsInJvbCI6M319:1vSPen:vjYQeRaQAWniVKN6lnCbwdZya1fB5-HAwJGEFGTjS_o	2025-12-21 19:03:17.576784-06
\.


--
-- Data for Name: pfm_attribute; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_attribute (attribute, typeofattrib, typeofget, sqlselect, nr, form, valuelist, "default") FROM stdin;
linkname	taQuoted	tgDirect		1	pfm_link	none	\N
value	taQuoted	tgDirect	\N	2	pfm_value	none	\N
sqlwhere	taQuoted	tgDirect		4	pfm_link	none	\N
orderby	taQuoted	tgDirect		5	pfm_link	none	\N
displayattrib	taQuoted	tgDirect		6	pfm_link	none	\N
description	taQuoted	tgDirect		3	pfm_value	none	\N
name	taQuoted	tgDirect		1	pfm_report	none	\N
description	taQuoted	tgDirect		2	pfm_report	none	\N
report	taQuoted	tgLink	select name, description from pfm_report order by name	1	pfm_section	none	\N
nr	taNotQuoted	tgDirect		7	pfm_attribute	none	\N
name	taQuoted	tgDirect		1	pfm_form	none	\N
tablename	taQuoted	tgDirect		2	pfm_form	none	\N
attribute	taQuoted	tgDirect		2	pfm_attribute	none	\N
sqlselect	taQuoted	tgDirect		5	pfm_attribute	none	\N
form	taQuoted	tgLink	SELECT name FROM pfm_form ORDER BY name	1	pfm_attribute	none	\N
fromform	taQuoted	tgLink	SELECT name FROM pfm_form ORDER BY name	2	pfm_link	none	\N
toform	taQuoted	tgLink	SELECT name FROM pfm_form ORDER BY name	3	pfm_link	none	\N
valuelist	taQuoted	tgLink	SELECT name FROM pfm_value_list ORDER BY name	1	pfm_value	none	\N
name	taQuoted	tgDirect		1	pfm_value_list	none	\N
sqlselect	taQuoted	tgDirect		3	pfm_report	none	\N
sqlselect	taQuoted	tgDirect	\N	4	pfm_form	none	\N
sqlfrom	taQuoted	tgDirect	\N	5	pfm_form	none	\N
groupby	taQuoted	tgDirect		6	pfm_form	none	\N
pkey	taQuoted	tgDirect		3	pfm_form	none	
default	taQuoted	tgDirect		8	pfm_attribute	none	
typeofattrib	taQuoted	tgList		3	pfm_attribute	typeofattribute	taQuoted
typeofget	taQuoted	tgList	\N	4	pfm_attribute	typeofget	tgDirect
valuelist	taQuoted	tgLink	SELECT name FROM pfm_value_list ORDER BY name	6	pfm_attribute	none	none
help	taQuoted	tgDirect		11	pfm_form	none	\N
showform	taQuoted	tgList		9	pfm_form	boolean	t
view	taQuoted	tgList		10	pfm_form	boolean	f
sqlorderby	taQuoted	tgDirect		7	pfm_form	none	
sqllimit	taQuoted	tgDirect		8	pfm_form	none	
summary	taQuoted	tgDirect		6	pfm_section	none	
fieldlist	taQuoted	tgDirect		5	pfm_section	none	\N
layout	taQuoted	tgList		4	pfm_section	layout	table
level	taNotQuoted	tgDirect		3	pfm_section	none	1
sqlselect	taQuoted	tgReadOnly		2	pfm_section	none	
\.


--
-- Data for Name: pfm_form; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_form (name, tablename, showform, view, sqlselect, sqlfrom, groupby, help, pkey, sqlorderby, sqllimit) FROM stdin;
pfm_attribute	pfm_attribute	f	f	attribute, typeofattrib, typeofget, sqlselect, nr, form, valuelist, "default"	pfm_attribute	\N	The table "pfm_attribute" defines all the properties of form attributes.\n\nIt has the following attributes:\n\n    - form : the "name" of the form to which the attribute\n      belongs;\n\n    - attribute : the name of the attribute; this must be equal\n      to the name of the corresponding attribute of the form's SQL\n      SELECT statement;\n\n    - typeofattrib : the type of attribute:\n\n        o taQuoted: the value provided by the user is put\n             between single quotes when it is transferred to SQL\n             UPDATE or INSERT statements;\n            \n        o taNotQuoted: the value provided by the user is not\n             quoted when it is transferred to SQL UPDATE or INSERT\n             statements.\n\n          Hint: In general, all attribute values must be quoted, exept\n                the values or expressions for numeric attributes.\n\n    - typeofget: defines how the user provides a value for the\n      attribute; possible values are:\n\n          o tgDirect: the user types the value directly;\n\n          o tgExpression: the user types an expression which is first\n            evaluated before it is passed to SQL UPDATE or INSERT;\n\n            Note: Even with tgDirect it is possible to enter an\n                  expression as new value for an attribute, but then\n                  the expression is evaluated by postgresql whereas\n                  with tgExpression, the expression is first evaluated\n                  by Tcl before the SQL statement is sent to\n                  postgresql.\n\n          o tgList: the user selects a value by means of a list box\n            containing a list of values defined in table "pfm_value";\n\n          o tgLink: the user selects a value by means of a list box\n            containing a list of values which is the result from a\n            query on another table.\n\n          o tgReadOnly: this attribute cannot be modified by\n            the user.\n\n            Note: All calculated attributes and all attributes from\n                  tables other than the form's main table should be\n                  declared 'read-only'. If this rule is not observed,\n                  the Add and Update operations on this form will fail.\n\n    - sqlselect: the SQL SELECT statement which is used to fill the\n      list box with possible values for the attribute (only meaningful\n      if typeofget = tgLink).\n\n      Note :\n\n         o The sqlselect may return more than 1 attribute. If so, all\n           the attributes are displayed in the list-box, but only the\n           first one is used for updating the attribute.\n\n    - valuelist : the "name" of the value list defined in table\n      "pfm_value_list" (only meaningful if typeofget = tgList);\n\n    - nr: a number which determines the order in which attributes are\n      displayed on the form;\n\n    - default: a default value for this attribute which is used when\n      adding a record. If the first character is an '=' sign, the\n      following characters should be an SQL SELECT statement which\n      returns just one value.\n\n      Example:\n\n      default: =SELECT nextval('seq_person_id')\n\n      In this example the default value is the next value of the\n      sequenece 'seq_person_id'.\n	form attribute	form, nr	\N
pfm_link	pfm_link	f	f	linkname, sqlwhere, orderby, displayattrib, fromform, toform	pfm_link	\N	A link is a navigation tool which allows you to follow a "one-to-many"\nor "many-to-one" relationship from one form to another.\n\nEvery link is stored as a record in the pfm_link table, which has the\nfollowing attributes:\n\n    - linkname : the name of the link, which is displayed on\n      a link button on the "fromform";\n\n    - fromform : the name of the form from which the link\n      originates;\n\n    - toform : the name of the form to which the link leads;\n\n    - sqlwhere : the "WHERE"-clause which is used to open the\n      "toform" and in which the value of an attribute of the\n      "fromform" may be represented by $(attrib-x), where\n      'attrib-x' is the name of the attribute;\n\n    - orderby : an 'order by' clause which determines the order of the\n      records in the 'toform';\n\n    - displayattrib : a space separated list of\n      attributes of the 'fromform', the value of which is displayed on\n      the 'toform' to remind the user from which record the link\n      originated.\n\nNote: Postgres Forms does not provide any checks to safeguard\n      the referential integrity of the data base in case of updates or\n      deletions. However, postgreSQL provides these functions as\n      'foreign key' table constraints (see postgreSQL documentation).	fromform linkname	fromform, linkname	\N
pfm_report	pfm_report	f	f	name, description, sqlselect	pfm_report	\N	The table pfm_report defines all the reports for the current data\nbase.\n\npfm_report has the following attributes:\n\n    - name: the name of the report. This is the name that\n      appears in the selection list of the "Run Report" function.\n\n    - description: free text describing the purpose of the\n      report in more detail.\n\n    - sqlselect: an SQL SELECT statement that generates the\n      data for the report.\n\nThe sqlselect may contain one or more parameters for which a\nvalue is requested at "Run report" time. A parameter in the sqlwhere\nmust be formatted as $(parameter_name).\n\nExample:\n\nsqlselect: \n\n    SELECT g.name AS "group", g.description, p.id, p.name,\n           p.christian_name, p.street, p."ZIPcode", p.town, p.country\n    FROM "group" g\n       LEFT JOIN memberlist m ON g.name = m."group"\n       LEFT JOIN person p ON m.person = p.id\n    WHERE "group" = '$(group)'\n    ORDER BY g.name, p.name, p.christian_name\n\nWhen the report is run, the user is prompted to enter a value for the\nparameter "group". Then the report data are generated by executing the\nsqlselect statement in which $(group) is replaced with the value\nentered by the user.	name	name	\N
pfm_value	pfm_value	f	f	value, description, valuelist	pfm_value	\N	The table "pfm_value" contains all the values of the lists defined in\npfm_value_list.\n\nIt has the following attributes:\n\n    - valuelist : the name of the valuelist to which this value belongs\n\n    - value : a character string;\n\n    - description : a description of the value.\n	valuelist value	valuelist, value	\N
pfm_value_list	pfm_value_list	f	f	name	pfm_value_list	\N	The table "pfm_value_list" contains all the value lists of all the forms.\n\nIts only attribute is\n\n    - name : a name uniquely identifying the value list.\n	name	name	\N
pfm_form	pfm_form	f	f	name, tablename, sqlselect, sqlfrom, groupby, showform, "view", help, pkey, sqlorderby, sqllimit	pfm_form	\N	A form allows the user to administer the data of just one table. This\ntable is henceforth referred to as "the form's main table".\n\nHowever, a form also has an SQL SELECT statement, which generates the\ndata that are displayed on it.\n\nIn the simplest case the SQL SELECT statement is just:\n\n    SELECT <attributes of main table> FROM <main table>\n\nIn that case, the data which can be administered and the data which\nare displayed on the form are the same.\n\nIn more complex cases, the <main table> can be JOINED with other\ntables, which makes it possible to display data of other related\ntables as well. These data cannot be modified by means of the form.\n\nThe table "pfm_form" has the following attributes:\n\n    - name : the name of the form (usually equal to the name of\n      the form's table);\n\n    - tablename : the name of the form's main table;\n\n    - pkey : the primary key of the form's main table, which may\n      consist of more than one attribute. In that case pkey is a SPACE\n      separated list of the attributes of the primary key;\n\n      Note: If pkey is empty, the form is read-only, since pfm is\n            unable to uniquely identify a record. You can use the\n            'oid' as primary key, but according to the PostgreSQL\n            documentation that is not recommended, unless you set a\n            UNIQUE constraint on the 'oid'.\n\n    - sqlselect : the attribute list of the form's SQL SELECT\n      statement, not including the word 'SELECT';\n\n    - sqlfrom : the FROM clause of the form's SQL SELECT statement,\n      not including the word 'FROM';\n\n    - groupby : an optional 'GROUP BY' clause, not including the words\n      'GROUP BY';\n\n    - sqlorderby : an optional 'ORDER BY' clause, not including the\n      words 'ORDER BY';\n\n    - sqllimit : an optional 'LIMIT' clause, only specifying the limit\n      value as a positive integer;\n\n      Notes:\n\n          - This enables the designer of the form to avoid excessive\n            memory usage by limiting the number of records loaded in\n            the form's internal buffer. This may be useful for\n            handling large tables.\n\n          - If sqllimit is a positive integer, a\n\n                   LIMIT sqllimit OFFSET 0\n\n            is added to the form's SELECT when opening the form.\n\n            This means that only 'sqllimit' records are loaded into\n            the form's internal buffer. When the user moves beyond the\n            last record in the internal buffer, the internal buffer is\n            first cleared and then reloaded with the next 'sqllimit'\n            records by re-executing the form's SELECT but now with\n            another OFFSET in the LIMIT clause.\n\n          - If sqllimit is an empty string, no LIMIT clause is\n            appended to the form's SELECT.\n\n          - Always specify an 'sqlorderby' if you specify an\n            'sqllimit'.  See PostgreSQL documentation of LIMIT-clause\n            in SELECT statement for more details.\n\n    - showform : a boolean indicating whether the form is shown\n      in "normal mode" (showform = 'true') or in "design mode"\n      (showform = 'false'). Typically, showform is set 'true' for user\n      defined forms and 'false' for the predefined pfm_* forms.\n\n    - view : a boolean indicating whether or not the\n      "tablename" is a view;\n\n    - help : a text which is displayed when the user presses\n      the [Help] key on the form.\n\nThe form's main table is defined by tablename. Only the data of\nthat table can be administered by using the form.\n\nAll the data generated by the form's SQL SELECT statement can be\ndisplayed on the form. The SQL SELECT statement is defined by:\n\n    - the sqlselect, sqlfrom, groupby, sqlorderby and sqllimit\n      attributes of pfm_form; and\n\n    - the optional WHERE and ORDER BY clauses provided by the user\n      when opening the form.\n\nNote: The WHERE clause provided by the user when opening the form, becomes\n      a HAVING clause, if there is a GROUP BY clause.\n\nThe following rules should be observed when filling out sqlselect and\nsqlfrom:\n\n    1. The form's main table must appear in 'sqlfrom', and must not be\n       aliased. Similarly, the main table's attributes appearing in\n       'sqlselect' must not be aliased. The other tables appearing in\n       the 'sqlfrom' may be aliased.\n\n    2. The fields appearing in 'sqlselect' must have a unique, simple\n       name without the need to precede them with a tablename. So,\n       calculated fields must be given a name by aliasing and\n       attributes of tables other than the main table may need to be\n       aliased in order to have a unique, simple name.\n\n    3. The 'sqlfrom' is either just the name of the form's main table,\n       or it is a JOIN clause in which the 'LEFT' table is the form's\n       main table. Several join clauses can be nested in order to\n       involve more than 2 tables. See examples below.\n\n\nExample 1: the SQL SELECT for the person form of the addressbook database\n\n\ntablename:\n    person\n\npkey:\n    id\n\nsqlselect:\n    id, christian_name, name, street, town, "ZIPcode",\n    country, category, description\n\nsqlfrom:\n    person\n\ngroupby:\n    -\n\n\nExample 2: the SQL SELECT for the memberlist form of the addressbook database\n\n\ntablename:\n    memberlist\n\npkey:\n    group person\n\nsqlselect:\n    memberlist."group", memberlist.person, p.christian_name, p.name\n\nsqlfrom:\n    memberlist LEFT OUTER JOIN person p ON (p.id = memberlist.person)\n\ngroupby:\n    -	name	showform DESC, name	\N
pfm_section	pfm_section	f	f	pfm_section.report, r.sqlselect, pfm_section."level", pfm_section.fieldlist,\npfm_section.layout, pfm_section.summary	pfm_section LEFT OUTER JOIN pfm_report r ON (pfm_section.report = r.name)	\N	The data returned by the report's SQL SELECT statement may be\nconsidered as a table with a column for each 'field' specified after\nthe word 'SELECT' and with a row for each record.\n\nBy specifying an 'ORDER BY' clause in the report's SQL SELECT\nstatement, it is possible to group rows with the same values for some\nfields together.\n\nThe report generator has an "economy" algorithm which avoids printing\nthe same data repeatedly.\n\nTo control this you have to distribute the fields (columns) of the\ntable over n sections such that section 1 contains the fields that are\nchanging least frequently (when moving from one row to the next),\nsection 2 contains the fields that are changing more frequently, and\nsection n contains the fields that are changing at every row.\n\nWhen the data of the first row of the table are printed, the data of\nsection 1 are printed first. Then, on the following line, indented by\none tab stop, the data of section 2 are printed. Then, on the\nfollowing line, indented by 2 tab stops, data of section 2 are\nprinted, etc.\n\n[section 1] <--- row 1\n\n    [section 2] <--- row 1\n\n        [section 3]  <--- row 1\n\nThen, when the next rows are being printed, data of the lower numbered\nsections are only printed if they are different from the data of the\nlast printed section of the same number:\n\n[section 1]\n\n    [section 2]\n\n        [section 3]  <--- row 1\n        [section 3]  <--- row 2\n        [section 3]  <--- row 3\n\n    [section 2]\n\n        [section 3]  <--- row 4\n        [section 3]  <--- row 5\n\n[section 1]\n\n    [section 2]\n\n        [section 3]  <--- row 6\n        [section 3]  <--- row 7\n\nThe report generator also enables you to print a summary at every\npoint where a higher numbered section is about to be followed by a\nlower numbered section:\n\n[section 1]\n\n    [section 2]\n\n        [section 3]  <--- row 1\n        [section 3]  <--- row 2\n        [section 3]  <--- row 3\n\n        [summary 3]\n\n    [section 2]\n\n        [section 3]  <--- row 4\n        [section 3]  <--- row 5\n\n        [summary 3]\n\n    [summary 2]\n\n[section 1]\n\n    [section 2]\n\n        [section 3]  <--- row 6\n        [section 3]  <--- row 7\n\n        [summary 3]\n\n    [summary 2]\n\n[summary 1]\n\nA summary i is printed just before a lower numbered section j (j < i).\nIts data can be calculated:\n\n    - by applying one of the aggregate funtions: COUNT, SUM, AVG,\n      STDDEV, MIN, MAX;\n\n    - on the fields of the sections j (j >= i), between the last\n      printed lower numbered section k (k < i), till the next (not\n      yet printed) lower numbered section k (k < i).\n\nIn particular, summary 1 is printed at the end of the report, is\ncalculated from all the sections of the report and may be calculated\nfrom all the fields.\n\nA record in pfm_section defines a section and a summary of a report.\n\nThe table pfm_section has the following attributes:\n\n    - report: the name of the report to which the section belongs\n\n    - level: a number 1, 2, 3, 4, ... . The first level must be\n      '1'. The next levels must be numbered consecutively. In the most\n      simple report, there is only a section with level 1.\n\n    - layout: can be "row", "column" or "table".\n\n    - fieldlist: a space separated list of field specifiers,\n      one for each field to be printed in the sections of this level\n      (see below for details).\n\n    - summary: a space separated list of summary field\n      specifiers (see below for details).\n\nThe fieldlist is a SPACE separated list of field specifiers\n\n    field_spec_1 field_spec_2 ... field_spec_N\n\nwhere each field specifier is formatted as follows:\n\n    {field_i label_i alignment_i max_length_i}\n\nwhere :\n\n    - field_i is the name of one of the columns returned by the\n      report's SQL SELECT statement;\n\n    - label_i is a string which has to be used as label for printing\n      the i-th field of this section; if it consists of more than 1\n      word, it must be delimited by double quotes (" .... ");\n\n    - alignment_i is optional; if present, it is either l or r,\n      indicating whether this field should be left or right aligned.\n\n    - max_length_i is optional: if present, it is the maximum number\n      of characters per line for printing the data of this field;\n      lines longer than max_length_i will be wrapped by inserting\n      one or more line breaks before printing.\n\n      Notes :\n\n          o The alignment is optional. If it is left out, left\n            alignment is assumed by default.\n\n          o The alignment only influences the table layout. Column and\n            row layouts are unaffected by the alignment indicator.\n\n          o Multi-line fields, i.e. fields containing more than one\n            line of text are only formatted properly in a column or\n            table layout.\n\n          o For a table layout, pfm automatically calculates the column\n            width that is required to display all data. So, normally\n            you don't have to worry about column widths. However,\n            sometimes, the data of a few records, make the columns\n            excessively wide. That is where you might consider using\n            "max_length_i" in the field specifier. If the data do not\n            exceed that maximum, it won't have any effect.\n\n          o Although 'alignment' and 'max_length' are both optional,\n            you have to specify 'alignment' if you want to specify\n            max_length.\n\nFor every section, the layout can be defined as:\n\n    - row: the section's field labels and field values are\n      printed in one row in a format: label_1 : value_1; label_2 :\n      value_2; ... etc.\n\n    - column: the section's field labels are printed in a first\n      column, the section's field values are printed in a second column.\n\n    - table: the section's values are printed in a table with a\n      column per field and a row per record, the section's field\n      labels are used as column headers for the table.\n\nThe summary must be formatted as a space separated list of summary\nspecifiers:\n\n    summary_spec_1 summary_sepc_2 .... summary_sepc_N\n\nwhere each summary_spec is formatted as follows:\n\n    {field_i aggregate_i format_i}\n\nwhere:\n\n    - field_i is the name of a field defined in the fieldlist of\n      either this section, or another, higher numbered section;\n\n    - aggregate_i is one of the aggregate functions: COUNT, SUM, AVG,\n      STDDEV, MIN, MAX (see below for details); and\n\n    - format_i is an optional 'ANSI C sprintf' formatting string (see\n      below for details). If it is left out, the number is printed\n      with maximum precision.\n\n\nAggregate functions:\n\nIn general, the aggregate functions, use the same "economy" algorithm\nthat is used for printing section data.\n\nWhen all the fields of a section, which is not the highest numbered\nsection of the report, have the same values for a number of\nconsecutive rows, this section's data are only printed once for these\nrows.\n\nSimilarly, these rows are only counted once by the aggregate functions\napplied to a field of this section.\n\nThe aggregate functions that can be used in a summary are:\n\n    - COUNT: Counts the number of rows. In this case, the field_i that\n           is specified only determines which section is counted.\n\n    - SUM: Calculates the sum of all the values of the specified\n           field.\n\n    - AVG: Calculates the average of the values of the specified\n           field.\n\n    - STDDEV: Calculates the sample standard deviation for the values of the\n           specified field:\n\n           SQRT (SUM( (value_i - AVG(value))**2 ) / (N - 1))\n\n\t   where :\n\n               - value_1, value_2, ... value_N are the values of the\n                 considered field;\n\n               - AVG(value) is the average of the considered values;\n\n               - N is the number of values.\n\n    - MIN: Calculates the minimum of the values of the specified\n           field.\n\n    - MAX: Calculated the maximum of the values of the specified\n           field.\n\n\n'ANSI C sprintf' formatting string:\n\nHere is a short overview of the 'ANSI C sprintf' formatting string. In\ngeneral its form is:\n\n     %'MinWidth'.'Precision''Conversion'\n\nwhere:\n\n    - 'MinWidth' is an integer defining the minimum width (as number\n      of characters) for the number to be printed. If the number does\n      not need so much space, spaces are inserted in front of the\n      number, unless MinWidth is negative. In that case, spaces are\n      appended at the end. If the number needs more space than\n      MinWidth, more space is used.\n\n    - 'Precision' is an integer defining how many digits to print\n      after the decimal point, or, in the case of g or G conversion,\n      the total number of digits to appear, including those on both\n      sides of the decimal point\n\n    - 'Conversion' is one of:\n\n          o d : convert integer to signed decimal string. In this case,\n                there is no need to define a 'Precision'.\n\n                Example: %1d\n\n                         prints an integer and uses as many characters\n                         as required.\n\n          o f : convert floating point number to fixed point\n                notation. In this case, 'Precision' defines the number\n                of digits to print after the decimal point. If there\n                are not enough digits available, trailing zeroes are\n                appended.\n\n                Example: %1.2f\n\n                         prints a floating point number wiht 2 digits\n                         after the decimal point and uses as many\n                         characters as required.\n\n          o e or E : Convert floating-point number to scientific\n                notation in the form x.yyye±zz, where the number of\n                y's is determined by the 'Precision' (default: 6). If\n                the precision is 0 then no decimal point is output. If\n                the E form is used then E is printed instead of e.\n\n                Example: %1.5E\n\n                         prints a floating point number in the form\n                         x.yyyyy E±zz \n\n          o g or G : If the exponent is less than -4 or greater than\n                or equal to the precision, then convert floating-point\n                number as for %e or %E. Otherwise convert as for\n                %f. Trailing zeroes and a trailing decimal point are\n                omitted. In this case the 'Precision' specifies the\n                total number of digits to appear, including those on\n                both sides of the decimal point\n\n                Example: %1.4G\n\n                          prints 2345.0 as 2345\n                          prints 234567.0 as 2.346E+05\n                          prints 0.003456 as 0.003456\n                          prints 0.00003456 as 3.456E-05	report level	report, "level"	\N
\.


--
-- Data for Name: pfm_link; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_link (linkname, sqlwhere, orderby, displayattrib, fromform, toform) FROM stdin;
Report	name='$(report)'		level	pfm_section	pfm_report
Sections	report='$(name)'	level	name	pfm_report	pfm_section
Attributes	form='$(name)'	nr	name	pfm_form	pfm_attribute
incoming links	toform='$(name)'	fromform	name	pfm_form	pfm_link
outgoing links	fromform='$(name)'	toform	name	pfm_form	pfm_link
Where used?	valuelist='$(name)'		name	pfm_value_list	pfm_attribute
Values	valuelist='$(name)'	value	name	pfm_value_list	pfm_value
Value list	name='$(valuelist)'		attribute	pfm_attribute	pfm_value_list
from Form	name='$(fromform)'		linkname	pfm_link	pfm_form
to Form	name='$(toform)'		linkname	pfm_link	pfm_form
Valuelist	name='$(valuelist)'		value	pfm_value	pfm_value_list
Form	name='$(form)'		attribute	pfm_attribute	pfm_form
\.


--
-- Data for Name: pfm_report; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_report (name, description, sqlselect) FROM stdin;
\.


--
-- Data for Name: pfm_section; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_section (report, level, fieldlist, layout, summary) FROM stdin;
\.


--
-- Data for Name: pfm_value; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_value (value, description, valuelist) FROM stdin;
taQuoted	Value must be enclosed in ' ' for SQL.	typeofattribute
taNotQuoted	Value must not be enclosed in ' ' for SQL.	typeofattribute
tgDirect	Value directly typed by user.	typeofget
tgExpression	Value may be given as an expression.	typeofget
tgList	Value comes from a valuelist.	typeofget
tgLink	Value comes from 'sqlselect'.	typeofget
t	TRUE	boolean
f	FALSE	boolean
column	A column for the labels, a second column for the corresponding values	layout
table	A table with the labels as table header	layout
row	Labels and values on 1 row	layout
tgReadOnly	User cannot change the value of this attribute	typeofget
\.


--
-- Data for Name: pfm_value_list; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_value_list (name) FROM stdin;
typeofattribute
typeofget
boolean
layout
none
\.


--
-- Data for Name: pfm_version; Type: TABLE DATA; Schema: public; Owner: admin_perfumance
--

COPY public.pfm_version (seqnr, version, date, comment) FROM stdin;
1	1.5.0	2025-11-05	install_pfm.sql
\.


--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin_perfumance
--

SELECT pg_catalog.setval('gestion_perfumance.actividad_id_actividad_seq', 2, true);


--
-- Name: cliente_id_cliente_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.cliente_id_cliente_seq', 4, true);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.compra_id_compra_seq', 1, false);


--
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.detalle_compra_id_detalle_compra_seq', 1, false);


--
-- Name: detalle_pago_id_detalle_pago_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin_perfumance
--

SELECT pg_catalog.setval('gestion_perfumance.detalle_pago_id_detalle_pago_seq', 1, false);


--
-- Name: detalle_venta_id_detalle_venta_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.detalle_venta_id_detalle_venta_seq', 1, false);


--
-- Name: direccion_id_direccion_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.direccion_id_direccion_seq', 1, false);


--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.empleado_id_empleado_seq', 1, true);


--
-- Name: genero_id_genero_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.genero_id_genero_seq', 1, false);


--
-- Name: pago_id_pago_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.pago_id_pago_seq', 1, false);


--
-- Name: perfume_id_perfume_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.perfume_id_perfume_seq', 17, true);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.proveedor_id_proveedor_seq', 1, false);


--
-- Name: rol_id_rol_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.rol_id_rol_seq', 1, false);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.usuario_id_usuario_seq', 5, true);


--
-- Name: venta_id_venta_seq; Type: SEQUENCE SET; Schema: gestion_perfumance; Owner: admin
--

SELECT pg_catalog.setval('gestion_perfumance.venta_id_venta_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- Name: pfm_version_seqnr_seq; Type: SEQUENCE SET; Schema: public; Owner: admin_perfumance
--

SELECT pg_catalog.setval('public.pfm_version_seqnr_seq', 1, true);


--
-- Name: actividad actividad_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id_actividad);


--
-- Name: cliente cliente_email_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.cliente
    ADD CONSTRAINT cliente_email_key UNIQUE (email);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);


--
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_detalle_compra);


--
-- Name: detalle_pago detalle_pago_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago
    ADD CONSTRAINT detalle_pago_pkey PRIMARY KEY (id_detalle_pago);


--
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_detalle_venta);


--
-- Name: direccion direccion_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.direccion
    ADD CONSTRAINT direccion_pkey PRIMARY KEY (id_direccion);


--
-- Name: empleado empleado_email_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.empleado
    ADD CONSTRAINT empleado_email_key UNIQUE (email);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id_empleado);


--
-- Name: genero genero_descripcion_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.genero
    ADD CONSTRAINT genero_descripcion_key UNIQUE (descripcion);


--
-- Name: genero genero_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.genero
    ADD CONSTRAINT genero_pkey PRIMARY KEY (id_genero);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id_pago);


--
-- Name: perfume perfume_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.perfume
    ADD CONSTRAINT perfume_pkey PRIMARY KEY (id_perfume);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);


--
-- Name: rol rol_descripcion_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.rol
    ADD CONSTRAINT rol_descripcion_key UNIQUE (descripcion);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_id_cliente_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_id_cliente_key UNIQUE (id_cliente);


--
-- Name: usuario usuario_id_empleado_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_id_empleado_key UNIQUE (id_empleado);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id_venta);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: pfm_attribute pfm_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_attribute
    ADD CONSTRAINT pfm_attribute_pkey PRIMARY KEY (form, attribute);


--
-- Name: pfm_form pfm_form_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_form
    ADD CONSTRAINT pfm_form_pkey PRIMARY KEY (name);


--
-- Name: pfm_link pfm_link_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_link
    ADD CONSTRAINT pfm_link_pkey PRIMARY KEY (fromform, linkname);


--
-- Name: pfm_report pfm_report_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_report
    ADD CONSTRAINT pfm_report_pkey PRIMARY KEY (name);


--
-- Name: pfm_section pfm_section_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_section
    ADD CONSTRAINT pfm_section_pkey PRIMARY KEY (report, level);


--
-- Name: pfm_value_list pfm_value_list_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_value_list
    ADD CONSTRAINT pfm_value_list_pkey PRIMARY KEY (name);


--
-- Name: pfm_value pfm_value_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_value
    ADD CONSTRAINT pfm_value_pkey PRIMARY KEY (valuelist, value);


--
-- Name: pfm_version pfm_version_pkey; Type: CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_version
    ADD CONSTRAINT pfm_version_pkey PRIMARY KEY (seqnr);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: actividad actividad_id_usuario_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.actividad
    ADD CONSTRAINT actividad_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES gestion_perfumance.usuario(id_usuario) ON DELETE SET NULL;


--
-- Name: compra compra_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.compra
    ADD CONSTRAINT compra_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES gestion_perfumance.proveedor(id_proveedor);


--
-- Name: detalle_compra detalle_compra_id_compra_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_compra
    ADD CONSTRAINT detalle_compra_id_compra_fkey FOREIGN KEY (id_compra) REFERENCES gestion_perfumance.compra(id_compra);


--
-- Name: detalle_compra detalle_compra_id_perfume_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_compra
    ADD CONSTRAINT detalle_compra_id_perfume_fkey FOREIGN KEY (id_perfume) REFERENCES gestion_perfumance.perfume(id_perfume);


--
-- Name: detalle_pago detalle_pago_id_cliente_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago
    ADD CONSTRAINT detalle_pago_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES gestion_perfumance.cliente(id_cliente);


--
-- Name: detalle_pago detalle_pago_id_pago_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago
    ADD CONSTRAINT detalle_pago_id_pago_fkey FOREIGN KEY (id_pago) REFERENCES gestion_perfumance.pago(id_pago) ON DELETE CASCADE;


--
-- Name: detalle_pago detalle_pago_id_perfume_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago
    ADD CONSTRAINT detalle_pago_id_perfume_fkey FOREIGN KEY (id_perfume) REFERENCES gestion_perfumance.perfume(id_perfume);


--
-- Name: detalle_pago detalle_pago_id_venta_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin_perfumance
--

ALTER TABLE ONLY gestion_perfumance.detalle_pago
    ADD CONSTRAINT detalle_pago_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES gestion_perfumance.venta(id_venta) ON DELETE CASCADE;


--
-- Name: detalle_venta detalle_venta_id_perfume_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_venta
    ADD CONSTRAINT detalle_venta_id_perfume_fkey FOREIGN KEY (id_perfume) REFERENCES gestion_perfumance.perfume(id_perfume);


--
-- Name: detalle_venta detalle_venta_id_venta_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.detalle_venta
    ADD CONSTRAINT detalle_venta_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES gestion_perfumance.venta(id_venta) ON DELETE CASCADE;


--
-- Name: direccion direccion_id_usuario_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.direccion
    ADD CONSTRAINT direccion_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES gestion_perfumance.usuario(id_usuario) ON DELETE CASCADE;


--
-- Name: empleado empleado_id_rol_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.empleado
    ADD CONSTRAINT empleado_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES gestion_perfumance.rol(id_rol);


--
-- Name: pago pago_id_cliente_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.pago
    ADD CONSTRAINT pago_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES gestion_perfumance.cliente(id_cliente);


--
-- Name: perfume perfume_id_genero_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.perfume
    ADD CONSTRAINT perfume_id_genero_fkey FOREIGN KEY (id_genero) REFERENCES gestion_perfumance.genero(id_genero);


--
-- Name: usuario usuario_id_cliente_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES gestion_perfumance.cliente(id_cliente);


--
-- Name: usuario usuario_id_empleado_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES gestion_perfumance.empleado(id_empleado);


--
-- Name: usuario usuario_id_rol_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.usuario
    ADD CONSTRAINT usuario_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES gestion_perfumance.rol(id_rol);


--
-- Name: venta venta_id_cliente_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.venta
    ADD CONSTRAINT venta_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES gestion_perfumance.cliente(id_cliente);


--
-- Name: venta venta_id_empleado_fkey; Type: FK CONSTRAINT; Schema: gestion_perfumance; Owner: admin
--

ALTER TABLE ONLY gestion_perfumance.venta
    ADD CONSTRAINT venta_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES gestion_perfumance.empleado(id_empleado);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pfm_attribute ref_form; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_attribute
    ADD CONSTRAINT ref_form FOREIGN KEY (form) REFERENCES public.pfm_form(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pfm_link ref_fromform; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_link
    ADD CONSTRAINT ref_fromform FOREIGN KEY (fromform) REFERENCES public.pfm_form(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pfm_value ref_list; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_value
    ADD CONSTRAINT ref_list FOREIGN KEY (valuelist) REFERENCES public.pfm_value_list(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pfm_section ref_sections; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_section
    ADD CONSTRAINT ref_sections FOREIGN KEY (report) REFERENCES public.pfm_report(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pfm_link ref_toform; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_link
    ADD CONSTRAINT ref_toform FOREIGN KEY (toform) REFERENCES public.pfm_form(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pfm_attribute ref_value_list; Type: FK CONSTRAINT; Schema: public; Owner: admin_perfumance
--

ALTER TABLE ONLY public.pfm_attribute
    ADD CONSTRAINT ref_value_list FOREIGN KEY (valuelist) REFERENCES public.pfm_value_list(name) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict e6vj6GXiz3cjRCflnQIH0kAHBJIJ5COLC2A1gfqrOYTDYXr7u7ltJIn3BGQvt6W

