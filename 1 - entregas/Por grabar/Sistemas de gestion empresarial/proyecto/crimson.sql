-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 11-11-2024 a las 16:58:24
-- Versión del servidor: 8.0.39-0ubuntu0.24.04.2
-- Versión de PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `crimson`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`crimson`@`localhost` PROCEDURE `EspanaEsES` ()   BEGIN
    UPDATE clientes
    SET pais = 'ES'
    WHERE pais = 'España';
END$$

CREATE DEFINER=`crimson`@`localhost` PROCEDURE `SeleccionaClientesBueno` (IN `cadena` VARCHAR(50))   BEGIN
    SELECT 
        CONCAT(nombre,' ',apellidos) AS nombrecompleto,
        email,
        direccion,
        poblacion
    FROM clientes
    WHERE nombre LIKE CONCAT('%', cadena, '%');
END$$

CREATE DEFINER=`crimson`@`localhost` PROCEDURE `SeleccionaClientesMalo` ()   BEGIN
    SELECT 
        CONCAT(nombre,' ',apellidos) AS nombrecompleto,
        email,
        direccion,
        poblacion
    FROM clientes
    WHERE nombre LIKE '%ju%';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aplicaciones`
--

CREATE TABLE `aplicaciones` (
  `Identificador` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `icono` varchar(255) NOT NULL,
  `ruta` varchar(255) NOT NULL,
  `activa` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `aplicaciones`
--

INSERT INTO `aplicaciones` (`Identificador`, `nombre`, `descripcion`, `icono`, `ruta`, `activa`) VALUES
(1, 'CRM', 'Un CRM es un sistema de gestión de la relación con el cliente. Con este sistema vas a poder realizar un seguimiento de tus clientes y de sus pedidos', 'crm.png', 'crm', 1),
(2, 'CMS', 'Un CMS, o Content Management System, es un sistema de gestión de contenidos donde varias personas de la empresa pueden introducir contenidos en texto', 'cms.png', 'cms', 1),
(4, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(5, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(6, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(7, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(8, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(9, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(10, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(11, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(12, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(13, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(14, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1),
(15, 'Blog', 'Un blog es un sistema en el cual los usuarios pueden introducir noticias', 'blog.png', 'blog', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `Identificador` int NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `apellidos` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `poblacion` varchar(255) DEFAULT NULL,
  `cp` varchar(255) DEFAULT NULL,
  `pais` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='En esta tabla guardamos los clientes de la aplicación';

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`Identificador`, `nombre`, `apellidos`, `email`, `direccion`, `poblacion`, `cp`, `pais`) VALUES
(1, 'Jose Vicente4', 'Carratala Sanchis', 'info@jocarsa.com', 'La calle de Jose Vicente', 'Valencia', '46000', 'Pais'),
(2, 'Juan', 'Garcia Martinez', 'juan@jocarsa.com', 'La calle deJuan', 'Valencia', '46643', 'ES'),
(3, 'Gerhard', 'Martinez Lope', 'suemail@email.com', 'Una calle mas', 'Essen', '54353', 'Alemania'),
(4, 'Luis', 'García Díaz', 'luis.garcía@yahoo.com', 'Calle 69, No 5', 'Población 35', '16115', 'ES'),
(5, 'María', 'Gómez Gómez', 'maría.gómez@yahoo.com', 'Calle 74, No 39', 'Población 18', '58437', 'ES'),
(6, 'Laura', 'López Rodríguez', 'laura.lópez@gmail.com', 'Calle 9, No 17', 'Población 25', '32616', 'ES'),
(7, 'Ana', 'Pérez Díaz', 'ana.pérez@gmail.com', 'Calle 58, No 48', 'Población 36', '27331', 'ES'),
(8, 'Juan', 'Martínez Gómez', 'juan.martínez@example.com', 'Calle 50, No 20', 'Población 32', '25974', 'ES'),
(9, 'Carlos', 'López Sánchez', 'carlos.lópez@hotmail.com', 'Calle 10, No 11', 'Población 28', '63797', 'ES'),
(10, 'Juan', 'Rodríguez Moreno', 'juan.rodríguez@yahoo.com', 'Calle 99, No 5', 'Población 31', '23826', 'ES'),
(11, 'José', 'Rodríguez Martínez', 'josé.rodríguez@hotmail.com', 'Calle 47, No 9', 'Población 19', '12380', 'ES'),
(12, 'Carlos', 'García Martínez', 'carlos.garcía@example.com', 'Calle 56, No 27', 'Población 26', '60364', 'ES'),
(13, 'Juan', 'Rodríguez Díaz', 'juan.rodríguez@gmail.com', 'Calle 55, No 22', 'Población 11', '30160', 'ES'),
(15, 'Carmen', 'Rodríguez Gómez', 'carmen.rodríguez@yahoo.com', 'Calle 64, No 42', 'Población 20', '20153', 'ES'),
(16, 'María', 'García Sánchez', 'maría.garcía@hotmail.com', 'Calle 95, No 9', 'Población 29', '45551', 'ES'),
(17, 'Pedro', 'Moreno Moreno', 'pedro.moreno@yahoo.com', 'Calle 96, No 24', 'Población 13', '27498', 'ES'),
(18, 'Pedro', 'Gómez Gómez', 'pedro.gómez@example.com', 'Calle 89, No 39', 'Población 31', '89858', 'ES'),
(19, 'Carmen', 'Sánchez Rodríguez', 'carmen.sánchez@gmail.com', 'Calle 30, No 3', 'Población 22', '21117', 'ES'),
(20, 'Carlos', 'Gómez Díaz', 'carlos.gómez@example.com', 'Calle 18, No 41', 'Población 29', '59064', 'ES'),
(21, 'Carmen', 'Rodríguez Sánchez', 'carmen.rodríguez@gmail.com', 'Calle 65, No 49', 'Población 12', '23188', 'ES'),
(22, 'Laura', 'Martínez Gómez', 'laura.martínez@gmail.com', 'Calle 26, No 29', 'Población 25', '66123', 'ES'),
(23, 'Pedro', 'López Sánchez', 'pedro.lópez@yahoo.com', 'Calle 82, No 39', 'Población 45', '45977', 'ES'),
(24, 'Ana', 'Rodríguez Rodríguez', 'ana.rodríguez@gmail.com', 'Calle 23, No 4', 'Población 50', '46015', 'ES'),
(25, 'Laura', 'López García', 'laura.lópez@gmail.com', 'Calle 39, No 14', 'Población 45', '83577', 'ES'),
(26, 'María', 'Rodríguez Vázquez', 'maría.rodríguez@gmail.com', 'Calle 39, No 34', 'Población 37', '45951', 'ES'),
(27, 'José', 'Vázquez Gómez', 'josé.vázquez@example.com', 'Calle 22, No 35', 'Población 22', '44398', 'ES'),
(28, 'Pedro', 'Gómez Martínez', 'pedro.gómez@yahoo.com', 'Calle 3, No 45', 'Población 40', '23667', 'ES'),
(29, 'Carmen', 'Martínez Gómez', 'carmen.martínez@example.com', 'Calle 67, No 32', 'Población 42', '47568', 'ES'),
(30, 'Ana', 'Pérez Gómez', 'ana.pérez@example.com', 'Calle 58, No 14', 'Población 43', '14349', 'ES'),
(31, 'María', 'Moreno García', 'maría.moreno@yahoo.com', 'Calle 21, No 9', 'Población 7', '76985', 'ES'),
(32, 'Jorge', 'Vázquez Martínez', 'jorge.vázquez@hotmail.com', 'Calle 97, No 11', 'Población 25', '77256', 'ES'),
(33, 'Laura', 'Martínez Moreno', 'laura.martínez@hotmail.com', 'Calle 96, No 19', 'Población 12', '31459', 'ES'),
(34, 'Pedro', 'Martínez Moreno', 'pedro.martínez@gmail.com', 'Calle 42, No 48', 'Población 19', '33280', 'ES'),
(35, 'Jorge', 'Vázquez Pérez', 'jorge.vázquez@hotmail.com', 'Calle 40, No 29', 'Población 4', '57589', 'ES'),
(36, 'Luis', 'Sánchez Pérez', 'luis.sánchez@hotmail.com', 'Calle 6, No 27', 'Población 40', '27405', 'ES'),
(37, 'Juan', 'García García', 'juan.garcía@yahoo.com', 'Calle 19, No 34', 'Población 3', '98492', 'ES'),
(38, 'José', 'Martínez Martínez', 'josé.martínez@gmail.com', 'Calle 63, No 11', 'Población 39', '37549', 'ES'),
(39, 'José', 'García García', 'josé.garcía@example.com', 'Calle 87, No 31', 'Población 29', '67015', 'ES'),
(40, 'María', 'Pérez Díaz', 'maría.pérez@hotmail.com', 'Calle 66, No 50', 'Población 20', '41001', 'ES'),
(41, 'María', 'García Díaz', 'maría.garcía@hotmail.com', 'Calle 45, No 4', 'Población 24', '46414', 'ES'),
(42, 'Carlos', 'Martínez Rodríguez', 'carlos.martínez@gmail.com', 'Calle 70, No 38', 'Población 7', '11712', 'ES'),
(43, 'Pedro', 'Moreno Gómez', 'pedro.moreno@hotmail.com', 'Calle 74, No 14', 'Población 35', '41354', 'ES'),
(44, 'Carmen', 'Moreno López', 'carmen.moreno@yahoo.com', 'Calle 19, No 3', 'Población 28', '21244', 'ES'),
(45, 'Luis', 'Díaz Gómez', 'luis.díaz@gmail.com', 'Calle 9, No 13', 'Población 16', '42093', 'ES'),
(46, 'Pedro', 'Pérez Sánchez', 'pedro.pérez@yahoo.com', 'Calle 43, No 24', 'Población 9', '20969', 'ES'),
(47, 'José', 'Rodríguez Vázquez', 'josé.rodríguez@example.com', 'Calle 18, No 13', 'Población 7', '11593', 'ES'),
(48, 'Pedro', 'Moreno Gómez', 'pedro.moreno@gmail.com', 'Calle 89, No 47', 'Población 50', '30173', 'ES'),
(49, 'Luis', 'Díaz Rodríguez', 'luis.díaz@yahoo.com', 'Calle 15, No 29', 'Población 32', '74318', 'ES'),
(50, 'Ana', 'Gómez López', 'ana.gómez@gmail.com', 'Calle 72, No 36', 'Población 39', '91941', 'ES'),
(51, 'Ana', 'Díaz Gómez', 'ana.díaz@hotmail.com', 'Calle 78, No 2', 'Población 37', '44122', 'ES'),
(52, 'Juan', 'Rodríguez López', 'juan.rodríguez@yahoo.com', 'Calle 69, No 1', 'Población 12', '87864', 'ES'),
(53, 'Pedro', 'Sánchez Díaz', 'pedro.sánchez@gmail.com', 'Calle 50, No 47', 'Población 1', '37947', 'ES'),
(54, 'José', 'Sánchez López', 'josé.sánchez@gmail.com', 'Calle 4, No 1', 'Población 21', '31242', 'ES'),
(55, 'María', 'García Gómez', 'maría.garcía@hotmail.com', 'Calle 79, No 26', 'Población 45', '70657', 'ES'),
(56, 'Ana', 'Sánchez Pérez', 'ana.sánchez@hotmail.com', 'Calle 57, No 49', 'Población 15', '60140', 'ES'),
(57, 'Juan', 'Vázquez Díaz', 'juan.vázquez@yahoo.com', 'Calle 43, No 17', 'Población 24', '91713', 'ES'),
(58, 'Pedro', 'Sánchez Martínez', 'pedro.sánchez@gmail.com', 'Calle 49, No 28', 'Población 16', '20177', 'ES'),
(59, 'Carmen', 'Vázquez Sánchez', 'carmen.vázquez@yahoo.com', 'Calle 14, No 48', 'Población 17', '35789', 'ES'),
(60, 'Pedro', 'Vázquez Gómez', 'pedro.vázquez@yahoo.com', 'Calle 83, No 44', 'Población 3', '27510', 'ES'),
(61, 'Jorge', 'Moreno Vázquez', 'jorge.moreno@gmail.com', 'Calle 25, No 29', 'Población 44', '69864', 'ES'),
(62, 'Laura', 'Sánchez Rodríguez', 'laura.sánchez@yahoo.com', 'Calle 49, No 32', 'Población 42', '43059', 'ES'),
(63, 'Ana', 'Díaz García', 'ana.díaz@example.com', 'Calle 23, No 12', 'Población 36', '41188', 'ES'),
(64, 'Jorge', 'Rodríguez García', 'jorge.rodríguez@example.com', 'Calle 64, No 20', 'Población 42', '33209', 'ES'),
(65, 'Carmen', 'Gómez Martínez', 'carmen.gómez@example.com', 'Calle 81, No 40', 'Población 1', '65645', 'ES'),
(66, 'Carmen', 'Pérez Moreno', 'carmen.pérez@hotmail.com', 'Calle 1, No 14', 'Población 49', '79678', 'ES'),
(67, 'José', 'Gómez López', 'josé.gómez@yahoo.com', 'Calle 63, No 38', 'Población 4', '65944', 'ES'),
(68, 'María', 'Sánchez García', 'maría.sánchez@hotmail.com', 'Calle 40, No 45', 'Población 14', '92435', 'ES'),
(69, 'Jorge', 'Rodríguez Rodríguez', 'jorge.rodríguez@yahoo.com', 'Calle 42, No 50', 'Población 33', '93244', 'ES'),
(70, 'Juan', 'Rodríguez Martínez', 'juan.rodríguez@example.com', 'Calle 99, No 38', 'Población 12', '98957', 'ES'),
(71, 'Juan', 'Sánchez Sánchez', 'juan.sánchez@gmail.com', 'Calle 87, No 26', 'Población 50', '42028', 'ES'),
(72, 'Carmen', 'Gómez Sánchez', 'carmen.gómez@gmail.com', 'Calle 6, No 38', 'Población 21', '31238', 'ES'),
(73, 'Ana', 'Vázquez Rodríguez', 'ana.vázquez@example.com', 'Calle 61, No 30', 'Población 40', '86296', 'ES'),
(74, 'José', 'Moreno Rodríguez', 'josé.moreno@hotmail.com', 'Calle 25, No 38', 'Población 22', '69748', 'ES'),
(75, 'Carmen', 'Gómez Díaz', 'carmen.gómez@gmail.com', 'Calle 91, No 37', 'Población 18', '53825', 'ES'),
(76, 'Jorge', 'Sánchez Moreno', 'jorge.sánchez@example.com', 'Calle 35, No 41', 'Población 16', '33447', 'ES'),
(77, 'Jorge', 'García Rodríguez', 'jorge.garcía@hotmail.com', 'Calle 56, No 20', 'Población 4', '37539', 'ES'),
(78, 'Jorge', 'Martínez Moreno', 'jorge.martínez@gmail.com', 'Calle 8, No 47', 'Población 14', '26336', 'ES'),
(79, 'Jorge', 'García Rodríguez', 'jorge.garcía@example.com', 'Calle 12, No 12', 'Población 14', '49690', 'ES'),
(80, 'Carlos', 'Moreno García', 'carlos.moreno@example.com', 'Calle 32, No 33', 'Población 5', '17278', 'ES'),
(81, 'José', 'Díaz Sánchez', 'josé.díaz@gmail.com', 'Calle 89, No 36', 'Población 47', '93537', 'ES'),
(82, 'José', 'Sánchez Martínez', 'josé.sánchez@gmail.com', 'Calle 24, No 50', 'Población 37', '71653', 'ES'),
(83, 'Laura', 'Rodríguez Gómez', 'laura.rodríguez@example.com', 'Calle 2, No 16', 'Población 45', '95898', 'ES'),
(86, 'vzx', 'fsadf', 'fasdfsadf', 'fsadf', 'fasdf', 'fasdf', 'sadf'),
(87, 'fasdf', 'asfdf', 'asdfsaf', 'fasd', 'fasd', 'safd', 'fasdf'),
(88, 'fasd', 'fasd', 'asdf', 'asdf', 'sadf', 'sadf', 'sadf'),
(89, 'zzz', 'zz', 'zzz', 'zzz', 'zz', 'zzz', 'zzz');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `clientes_resumido`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `clientes_resumido` (
`Identificador` int
,`nombre` varchar(255)
,`apellidos` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lineaspedido`
--

CREATE TABLE `lineaspedido` (
  `Identificador` int NOT NULL,
  `pedidos_fecha` int NOT NULL,
  `productos_nombre` int NOT NULL,
  `cantidad` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `lineaspedido`
--

INSERT INTO `lineaspedido` (`Identificador`, `pedidos_fecha`, `productos_nombre`, `cantidad`) VALUES
(1, 1, 1, 1),
(2, 2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `Identificador` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `clientes_nombre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='En esta tabla guardamos los pedidos que se gestionan en la aplicacion';

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`Identificador`, `fecha`, `clientes_nombre`) VALUES
(1, '2024-10-15', 1),
(2, '2024-10-28', 1),
(3, '2024-11-04', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `Identificador` int NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  `fotografia` longblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`Identificador`, `nombre`, `descripcion`, `precio`, `fotografia`) VALUES
(1, 'Mochila de niño', 'Mochila muy grande', 10.00, NULL),
(8, 'jv', '', 322.00, 0x4172726179),
(9, 'rwqtwqrt', '', 534.00, 0x4172726179),
(10, 'gae', '', 5.00, 0x4172726179),
(11, 'wrqerwqr', '', 5345.00, 0x4172726179),
(12, 'wrqerwqr', '', 5345.00, 0x4172726179),
(13, 'fsfad', 'fsd', 53453.00, 0x4172726179),
(14, 'fsfad', 'fsd', 53453.00, 0x4172726179),
(15, 'fsfad', 'fsd', 53453.00, 0x4172726179);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seleccion_clientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seleccion_clientes` (
`nombrecompleto` varchar(511)
,`email` varchar(255)
,`direccion` varchar(255)
,`poblacion` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `Identificador` int NOT NULL,
  `usuario` varchar(100) NOT NULL,
  `contrasena` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`Identificador`, `usuario`, `contrasena`, `nombre`, `apellidos`) VALUES
(1, 'jocarsa', 'jocarsa', 'Jose Vicente', 'Carratalá Sanchis');

-- --------------------------------------------------------

--
-- Estructura para la vista `clientes_resumido`
--
DROP TABLE IF EXISTS `clientes_resumido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `clientes_resumido`  AS SELECT `clientes`.`Identificador` AS `Identificador`, `clientes`.`nombre` AS `nombre`, `clientes`.`apellidos` AS `apellidos` FROM `clientes` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `seleccion_clientes`
--
DROP TABLE IF EXISTS `seleccion_clientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`crimson`@`localhost` SQL SECURITY DEFINER VIEW `seleccion_clientes`  AS SELECT concat(`clientes`.`nombre`,' ',`clientes`.`apellidos`) AS `nombrecompleto`, `clientes`.`email` AS `email`, `clientes`.`direccion` AS `direccion`, `clientes`.`poblacion` AS `poblacion` FROM `clientes` WHERE (`clientes`.`nombre` like '%ju%') ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aplicaciones`
--
ALTER TABLE `aplicaciones`
  ADD PRIMARY KEY (`Identificador`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`Identificador`);

--
-- Indices de la tabla `lineaspedido`
--
ALTER TABLE `lineaspedido`
  ADD PRIMARY KEY (`Identificador`),
  ADD KEY `lineaspedidoapedido` (`pedidos_fecha`),
  ADD KEY `lineaspedidoaproducto` (`productos_nombre`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`Identificador`),
  ADD KEY `pedidosaclientes` (`clientes_nombre`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`Identificador`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`Identificador`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aplicaciones`
--
ALTER TABLE `aplicaciones`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT de la tabla `lineaspedido`
--
ALTER TABLE `lineaspedido`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `lineaspedido`
--
ALTER TABLE `lineaspedido`
  ADD CONSTRAINT `lineaspedidoapedido` FOREIGN KEY (`pedidos_fecha`) REFERENCES `pedidos` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `lineaspedidoaproducto` FOREIGN KEY (`productos_nombre`) REFERENCES `productos` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidosaclientes` FOREIGN KEY (`clientes_nombre`) REFERENCES `clientes` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
