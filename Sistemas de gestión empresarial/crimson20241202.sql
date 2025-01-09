-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 02-12-2024 a las 16:13:30
-- Versión del servidor: 8.0.40-0ubuntu0.24.04.1
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
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `icono` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ruta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `activa` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `aplicaciones`
--

INSERT INTO `aplicaciones` (`Identificador`, `nombre`, `descripcion`, `icono`, `ruta`, `activa`) VALUES
(1, 'ventas', '', '', 'ventas', 1),
(2, 'facturacion', '', '', 'facturacion', 1),
(3, 'contabilidad', '', '', 'contabilidad', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `Identificador` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `apellidos` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `poblacion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pais` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci COMMENT='En esta tabla guardamos los clientes de la aplicación';

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
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `Identificador` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`Identificador`, `nombre`, `descripcion`) VALUES
(1, 'ventas', 'Esta es la descripción del departamento de ventas'),
(2, 'facturacion', 'Esta es la descripcion del departamento de facturacion');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentosaplicaciones`
--

CREATE TABLE `departamentosaplicaciones` (
  `Identificador` int NOT NULL,
  `departamentos_nombre` int NOT NULL,
  `aplicaciones_nombre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `departamentosaplicaciones`
--

INSERT INTO `departamentosaplicaciones` (`Identificador`, `departamentos_nombre`, `aplicaciones_nombre`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lineaspedido`
--

CREATE TABLE `lineaspedido` (
  `Identificador` int NOT NULL,
  `pedidos_fecha` int NOT NULL,
  `productos_nombre` int NOT NULL,
  `cantidad` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `Identificador` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `clientes_nombre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci COMMENT='En esta tabla guardamos los pedidos que se gestionan en la aplicacion';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `Identificador` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `precio` decimal(10,2) NOT NULL,
  `fotografia` longblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registros`
--

CREATE TABLE `registros` (
  `Identificador` int NOT NULL,
  `epoch` int NOT NULL,
  `ip` varchar(255) NOT NULL,
  `navegador` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `comentarios` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `registros`
--

INSERT INTO `registros` (`Identificador`, `epoch`, `ip`, `navegador`, `url`, `comentarios`) VALUES
(1, 1732037016, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=tabla&tabla=aplicaciones', ''),
(2, 1732037026, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(3, 1732037031, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=tabla&tabla=aplicaciones', ''),
(4, 1732037033, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=listatablas', ''),
(5, 1732037033, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=estadisticastablas', ''),
(6, 1732037037, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=columnastabla&tabla=clientes', ''),
(7, 1732037037, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=tabla&tabla=clientes', ''),
(8, 1732037045, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=columnastabla&tabla=registros', ''),
(9, 1732037046, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=tabla&tabla=registros', ''),
(10, 1732037282, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(11, 1732037283, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(12, 1732037284, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(13, 1732037284, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(14, 1732037355, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(15, 1732037355, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(16, 1732037355, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(17, 1732037356, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/103-insertar%20registros/servidor/?o=buscar&tabla=usuarios', ''),
(18, 1732037765, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/', ''),
(19, 1732037771, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(20, 1732037773, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(21, 1732037774, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(22, 1732037775, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(23, 1732037775, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(24, 1732037775, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(25, 1732037775, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(26, 1732037775, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(27, 1732037776, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(28, 1732037776, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(29, 1732037776, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(30, 1732037777, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(31, 1732037777, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(32, 1732037777, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(33, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(34, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(35, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(36, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(37, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(38, 1732037778, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(39, 1732037779, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(40, 1732037779, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(41, 1732037779, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(42, 1732037784, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(43, 1732037784, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(44, 1732037784, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(45, 1732037784, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(46, 1732037784, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(47, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(48, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(49, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(50, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(51, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(52, 1732037785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(53, 1732037786, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(54, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(55, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(56, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(57, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(58, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(59, 1732037828, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(60, 1732037829, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(61, 1732037829, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(62, 1732037829, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(63, 1732037829, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(64, 1732037829, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(65, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(66, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(67, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(68, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(69, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(70, 1732037830, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(71, 1732037831, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(72, 1732037831, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(73, 1732037831, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(74, 1732037831, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(75, 1732037831, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(76, 1732037832, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(77, 1732037832, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(78, 1732037832, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(79, 1732037848, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/', ''),
(80, 1732037897, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(81, 1732037898, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(82, 1732037898, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(83, 1732037898, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(84, 1732037898, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(85, 1732037899, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(86, 1732037899, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(87, 1732037899, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(88, 1732037899, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(89, 1732037900, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(90, 1732038169, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(91, 1732038172, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(92, 1732038173, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(93, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(94, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(95, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(96, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(97, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(98, 1732038192, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(99, 1732038193, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(100, 1732038193, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', ''),
(101, 1732038193, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(102, 1732038193, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(103, 1732038193, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(104, 1732038194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(105, 1732038194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(106, 1732038194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(107, 1732038194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(108, 1732038194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=buscar&tabla=usuarios', 'BLOQUEO FUERZA BRUTA'),
(109, 1732043189, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/?o=buscar&tabla=usuarios', ''),
(110, 1732043213, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/?o=buscar&tabla=usuarios', ''),
(111, 1732043218, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=aplicaciones', ''),
(112, 1732043231, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(113, 1732043231, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(114, 1732043231, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(115, 1732043248, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/', ''),
(116, 1732043264, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/', ''),
(117, 1732043287, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/?o=buscar&tabla=usuarios', ''),
(118, 1732043292, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=aplicaciones', ''),
(119, 1732043303, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(120, 1732043303, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(121, 1732043303, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(122, 1732043308, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(123, 1732043308, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(124, 1732043324, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(125, 1732043372, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(126, 1732043391, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(127, 1732043391, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(128, 1732043391, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(129, 1732043392, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(130, 1732043392, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(131, 1732043398, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(132, 1732043451, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(133, 1732043451, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(134, 1732043451, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(135, 1732043452, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(136, 1732043452, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(137, 1732043458, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(138, 1732043476, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listatablas', ''),
(139, 1732043476, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listacolecciones', ''),
(140, 1732043476, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=estadisticastablas', ''),
(141, 1732043477, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes', ''),
(142, 1732043477, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=tabla&tabla=clientes', ''),
(143, 1732043484, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=insertar&tabla=clientes', 'BLOQUEO FUERZA BRUTA'),
(144, 1732043490, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes', 'BLOQUEO FUERZA BRUTA'),
(145, 1732043499, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes', 'BLOQUEO FUERZA BRUTA'),
(146, 1732043507, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes_resumido', 'BLOQUEO FUERZA BRUTA'),
(147, 1732043509, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=lineaspedido', 'BLOQUEO FUERZA BRUTA'),
(148, 1732043510, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes', 'BLOQUEO FUERZA BRUTA'),
(149, 1732043513, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=estadisticastablas', 'BLOQUEO FUERZA BRUTA'),
(150, 1732043513, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listatablas', 'BLOQUEO FUERZA BRUTA'),
(151, 1732043513, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listacolecciones', 'BLOQUEO FUERZA BRUTA'),
(152, 1732043516, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listacolecciones', 'BLOQUEO FUERZA BRUTA'),
(153, 1732043516, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=estadisticastablas', 'BLOQUEO FUERZA BRUTA'),
(154, 1732043516, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listatablas', 'BLOQUEO FUERZA BRUTA'),
(155, 1732043533, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listatablas', 'BLOQUEO FUERZA BRUTA'),
(156, 1732043533, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listacolecciones', 'BLOQUEO FUERZA BRUTA'),
(157, 1732043533, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=estadisticastablas', 'BLOQUEO FUERZA BRUTA'),
(158, 1732043557, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(159, 1732043557, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(160, 1732043557, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(161, 1732043559, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(162, 1732043559, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(163, 1732043564, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(164, 1732043596, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listacolecciones', ''),
(165, 1732043596, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=listatablas', ''),
(166, 1732043596, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=estadisticastablas', ''),
(167, 1732043598, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=columnastabla&tabla=clientes', ''),
(168, 1732043598, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=tabla&tabla=clientes', ''),
(169, 1732043603, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/104-fuerza%20bruta/servidor/?o=insertar&tabla=clientes', ''),
(170, 1732043634, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(171, 1732043634, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(172, 1732043634, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(173, 1732043635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(174, 1732043635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(175, 1732043656, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(176, 1732043692, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(177, 1732043701, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(178, 1732043701, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(179, 1732043706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(180, 1732043706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(181, 1732043706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(182, 1732043708, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(183, 1732043708, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(184, 1732043725, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(185, 1732043725, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(186, 1732043725, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(187, 1732043727, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(188, 1732043727, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(189, 1732043731, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(190, 1732043822, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(191, 1732043822, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(192, 1732043822, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(193, 1732043824, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(194, 1732043824, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(195, 1732043827, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(196, 1732043874, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', '');
INSERT INTO `registros` (`Identificador`, `epoch`, `ip`, `navegador`, `url`, `comentarios`) VALUES
(197, 1732043874, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(198, 1732043874, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(199, 1732043875, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(200, 1732043876, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(201, 1732043880, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(202, 1732043907, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(203, 1732043907, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(204, 1732043907, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(205, 1732043908, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(206, 1732043908, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(207, 1732043911, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(208, 1732043919, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(209, 1732043919, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(210, 1732043919, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(211, 1732043921, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(212, 1732043921, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(213, 1732043925, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(214, 1732044073, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(215, 1732044073, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(216, 1732044073, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(217, 1732044074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(218, 1732044074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(219, 1732044077, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(220, 1732044126, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(221, 1732044126, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(222, 1732044126, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(223, 1732044127, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(224, 1732044127, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(225, 1732044131, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(226, 1732044242, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(227, 1732044242, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(228, 1732044242, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(229, 1732044250, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(230, 1732044250, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(231, 1732044250, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(232, 1732044251, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(233, 1732044251, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(234, 1732044256, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(235, 1732044296, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(236, 1732044296, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(237, 1732044296, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(238, 1732044297, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(239, 1732044297, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(240, 1732044301, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(241, 1732044426, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(242, 1732044426, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(243, 1732044426, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(244, 1732044430, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(245, 1732044430, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(246, 1732044430, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(247, 1732044435, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(248, 1732044435, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(249, 1732044435, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(250, 1732044436, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(251, 1732044436, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(252, 1732044440, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(253, 1732044446, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(254, 1732044446, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(255, 1732044471, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(256, 1732044472, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(257, 1732044472, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(258, 1732044473, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(259, 1732044473, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(260, 1732044482, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(261, 1732044482, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(262, 1732044484, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(263, 1732044484, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(264, 1732044501, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(265, 1732044501, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(266, 1732044520, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(267, 1732044522, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(268, 1732044522, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(269, 1732044540, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(270, 1732044540, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(271, 1732044540, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(272, 1732044542, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(273, 1732044542, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(274, 1732044547, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(275, 1732044550, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(276, 1732044550, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(277, 1732044560, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=eliminar&tabla=clientes&id=3', ''),
(278, 1732044561, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=eliminar&tabla=clientes&id=2', ''),
(279, 1732044562, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=eliminar&tabla=clientes&id=1', ''),
(280, 1732044563, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listatablas', ''),
(281, 1732044563, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=listacolecciones', ''),
(282, 1732044563, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=estadisticastablas', ''),
(283, 1732044565, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(284, 1732044565, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(285, 1732044584, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=insertar&tabla=clientes', ''),
(286, 1732044586, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=columnastabla&tabla=clientes', ''),
(287, 1732044586, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/105-codificador/servidor/?o=tabla&tabla=clientes', ''),
(288, 1732045065, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(289, 1732045065, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listacolecciones', ''),
(290, 1732045065, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(291, 1732045066, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(292, 1732045066, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(293, 1732045069, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(294, 1732045069, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(295, 1732045080, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/106-desencriptar/servidor/', ''),
(296, 1732045089, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(297, 1732045136, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(298, 1732045149, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listacolecciones', ''),
(299, 1732045149, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(300, 1732045149, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(301, 1732045152, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(302, 1732045152, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(303, 1732045163, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=insertar&tabla=clientes', ''),
(304, 1732045165, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(305, 1732045165, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(306, 1732045190, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=productos', ''),
(307, 1732045190, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(308, 1732045213, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=productos', ''),
(309, 1732045213, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(310, 1732045221, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=productos', ''),
(311, 1732045221, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(312, 1732275801, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(313, 1732275801, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(314, 1732554348, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(315, 1732554348, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(316, 1732554359, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(317, 1732554359, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(318, 1732554378, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=insertar&tabla=clientes', ''),
(319, 1732554381, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(320, 1732554381, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(321, 1732554383, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(322, 1732554383, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(323, 1733148122, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(324, 1733148122, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(325, 1733148124, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(326, 1733148124, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(327, 1733149243, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/106-desencriptar/servidor/?o=buscar&tabla=usuarios', ''),
(328, 1733149248, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=aplicaciones', ''),
(329, 1733149303, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=listatablas', ''),
(330, 1733149303, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=estadisticastablas', ''),
(331, 1733149305, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(332, 1733149305, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(333, 1733149310, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=lineaspedido', ''),
(334, 1733149310, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=pedidos', ''),
(335, 1733149310, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(336, 1733149310, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=lineaspedido', ''),
(337, 1733149312, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=pedidos', ''),
(338, 1733149312, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(339, 1733149312, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=pedidos', ''),
(340, 1733149313, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=productos', ''),
(341, 1733149313, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(342, 1733149315, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(343, 1733149315, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(344, 1733149316, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=lineaspedido', ''),
(345, 1733149316, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=pedidos', ''),
(346, 1733149316, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=productos', ''),
(347, 1733149316, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=lineaspedido', ''),
(348, 1733149318, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(349, 1733149318, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(350, 1733149319, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(351, 1733149319, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=aplicaciones', ''),
(352, 1733149320, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=clientes', ''),
(353, 1733149320, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=clientes', ''),
(354, 1733149332, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(355, 1733149332, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/106-desencriptar/servidor/?o=tabla&tabla=aplicaciones', ''),
(356, 1733149607, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=buscar&tabla=usuarios', ''),
(357, 1733149612, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(358, 1733149620, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(359, 1733149620, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(360, 1733149622, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(361, 1733149622, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(362, 1733149624, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(363, 1733149624, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(364, 1733149626, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(365, 1733149626, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(366, 1733149630, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=eliminar&tabla=clientes&id=7', ''),
(367, 1733149631, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=eliminar&tabla=clientes&id=5', ''),
(368, 1733149633, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=eliminar&tabla=clientes&id=6', ''),
(369, 1733149634, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=eliminar&tabla=clientes&id=4', ''),
(370, 1733149635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(371, 1733149635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(372, 1733149635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes_resumido', ''),
(373, 1733149635, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes_resumido', ''),
(374, 1733149636, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(375, 1733149636, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(376, 1733149638, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(377, 1733149638, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(378, 1733149706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(379, 1733149706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(380, 1733149706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(381, 1733149706, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(382, 1733149730, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=insertar&tabla=aplicaciones', ''),
(383, 1733149732, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=clientes', ''),
(384, 1733149732, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(385, 1733149732, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(386, 1733149732, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(387, 1733149749, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=insertar&tabla=aplicaciones', ''),
(388, 1733149751, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(389, 1733149751, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(390, 1733149752, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(391, 1733149752, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', '');
INSERT INTO `registros` (`Identificador`, `epoch`, `ip`, `navegador`, `url`, `comentarios`) VALUES
(392, 1733149772, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=insertar&tabla=aplicaciones', ''),
(393, 1733149773, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=aplicaciones', ''),
(394, 1733149773, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(395, 1733149905, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=actualizar', ''),
(396, 1733149918, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=buscar&tabla=usuarios', ''),
(397, 1733149923, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(398, 1733149933, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(399, 1733149933, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(400, 1733149941, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(401, 1733149941, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(402, 1733149950, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(403, 1733149950, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(404, 1733149955, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(405, 1733149955, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(406, 1733150068, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(407, 1733150068, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(408, 1733150074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=lineaspedido', ''),
(409, 1733150074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=pedidos', ''),
(410, 1733150074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=productos', ''),
(411, 1733150074, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=lineaspedido', ''),
(412, 1733150075, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=columnastabla&tabla=pedidos', ''),
(413, 1733150075, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=pedidos', ''),
(414, 1733150075, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=clientes', ''),
(415, 1733150189, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=buscar&tabla=usuarios', ''),
(416, 1733150195, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(417, 1733150233, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=tabla&tabla=aplicaciones', ''),
(418, 1733150236, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(419, 1733150236, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(420, 1733150245, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(421, 1733150245, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(422, 1733150264, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=listatablas', ''),
(423, 1733150264, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/107-Desactivo%20encriptacion%20fuerte/servidor/?o=estadisticastablas', ''),
(424, 1733150276, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=buscar&tabla=usuarios', ''),
(425, 1733150281, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=tabla&tabla=aplicaciones', ''),
(426, 1733150283, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=listatablas', ''),
(427, 1733150283, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=estadisticastablas', ''),
(428, 1733150289, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=tabla&tabla=aplicaciones', ''),
(429, 1733150290, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=listatablas', ''),
(430, 1733150290, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/108-de%20escritorio%20a%20controlador%20con%20parametros/servidor/?o=estadisticastablas', ''),
(431, 1733151503, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(432, 1733151511, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(433, 1733151551, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(434, 1733151593, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(435, 1733151650, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(436, 1733151651, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(437, 1733151653, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(438, 1733151682, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(439, 1733151709, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(440, 1733151741, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(441, 1733151741, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(442, 1733151760, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(443, 1733151760, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(444, 1733151770, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(445, 1733151770, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(446, 1733151785, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(447, 1733151786, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=facturacion', ''),
(448, 1733151786, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(449, 1733151789, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(450, 1733151789, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(451, 1733151792, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(452, 1733151792, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(453, 1733151796, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=columnastabla&tabla=pedidos', ''),
(454, 1733151796, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=clientes', ''),
(455, 1733151796, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=pedidos', ''),
(456, 1733151801, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=contabilidad', ''),
(457, 1733151801, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(458, 1733151803, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=facturacion', ''),
(459, 1733151803, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(460, 1733151805, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(461, 1733151805, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(462, 1733151815, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(463, 1733151815, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(464, 1733151820, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=facturacion', ''),
(465, 1733151820, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(466, 1733151823, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=contabilidad', ''),
(467, 1733151823, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(468, 1733151837, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(469, 1733151838, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(470, 1733151838, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(471, 1733151873, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(472, 1733151873, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(473, 1733151876, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(474, 1733151876, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(475, 1733151879, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=facturacion', ''),
(476, 1733151879, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(477, 1733151882, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=contabilidad', ''),
(478, 1733151882, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(479, 1733151930, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(480, 1733151959, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(481, 1733151959, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=estadisticastablas', ''),
(482, 1733152440, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=buscar&tabla=usuarios', ''),
(483, 1733152445, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/109-Cargo%20solo%20las%20tablas%20que%20me%20corresponden/servidor/?o=tabla&tabla=aplicaciones', ''),
(484, 1733152969, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(485, 1733152974, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(486, 1733152998, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(487, 1733153003, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=facturacion', ''),
(488, 1733153072, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(489, 1733153077, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(490, 1733153086, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(491, 1733153091, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=facturacion', ''),
(492, 1733153144, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(493, 1733153149, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=facturacion', ''),
(494, 1733153184, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(495, 1733153189, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(496, 1733153197, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=buscar&tabla=usuarios', ''),
(497, 1733153202, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listadoaplicacionesusuario&usuario=facturacion', ''),
(498, 1733153315, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(499, 1733153315, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=estadisticastablas', ''),
(500, 1733153318, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=listatablasaplicacion&aplicacion=facturacion', ''),
(501, 1733153318, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/110-aplicaciones%20por%20usuario/servidor/?o=estadisticastablas', ''),
(502, 1733153421, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(503, 1733153426, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=jocarsa', ''),
(504, 1733153439, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(505, 1733153439, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=estadisticastablas', ''),
(506, 1733153441, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=null', ''),
(507, 1733153508, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=null', ''),
(508, 1733153513, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=null', ''),
(509, 1733153746, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(510, 1733153773, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(511, 1733153783, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(512, 1733153816, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(513, 1733153862, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(514, 1733153870, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(515, 1733153899, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(516, 1733153904, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(517, 1733153935, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(518, 1733153940, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=jocarsa', ''),
(519, 1733153992, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=buscar&tabla=usuarios', ''),
(520, 1733153997, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/111-Cerrar%20sesion/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(521, 1733154237, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=buscar&tabla=usuarios', ''),
(522, 1733154242, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(523, 1733154328, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(524, 1733154353, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(525, 1733154358, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(526, 1733154445, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=buscar&tabla=usuarios', ''),
(527, 1733154451, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(528, 1733154496, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(529, 1733154496, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=estadisticastablas', ''),
(530, 1733154496, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listatablasaplicacion&aplicacion=ventas', ''),
(531, 1733154496, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=estadisticastablas', ''),
(532, 1733154498, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%C3%B3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(533, 1733154507, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=null', ''),
(534, 1733154523, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=buscar&tabla=usuarios', ''),
(535, 1733154528, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(536, 1733154571, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=null', ''),
(537, 1733154586, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/112-Cerrar%20sesion%20manual/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(538, 1733154686, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(539, 1733154701, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(540, 1733154816, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(541, 1733154816, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(542, 1733154837, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(543, 1733154837, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(544, 1733154857, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(545, 1733154857, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(546, 1733154871, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(547, 1733154871, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(548, 1733154878, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(549, 1733154878, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(550, 1733154907, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(551, 1733154907, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(552, 1733155017, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(553, 1733155017, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(554, 1733155019, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(555, 1733155031, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(556, 1733155044, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(557, 1733155055, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(558, 1733155082, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(559, 1733155141, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(560, 1733155177, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(561, 1733155177, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(562, 1733155190, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(563, 1733155190, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(564, 1733155194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=gasfsafdsf', ''),
(565, 1733155194, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(566, 1733155206, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=buscar&tabla=usuarios', ''),
(567, 1733155211, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(568, 1733155211, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', '');
INSERT INTO `registros` (`Identificador`, `epoch`, `ip`, `navegador`, `url`, `comentarios`) VALUES
(569, 1733155219, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(570, 1733155219, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(571, 1733155231, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(572, 1733155231, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(573, 1733155245, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(574, 1733155245, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(575, 1733155258, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(576, 1733155258, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(577, 1733155277, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(578, 1733155277, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(579, 1733155291, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTIwNg==', ''),
(580, 1733155291, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(581, 1733155300, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=buscar&tabla=usuarios', ''),
(582, 1733155305, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=MTczMzE1NTMwMA==', ''),
(583, 1733155305, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', ''),
(584, 1733155320, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=compruebatoken&token=null', ''),
(585, 1733155320, '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '/dam/Segundo/Sistemas%20de%20gesti%c3%b3n%20empresarial/proyecto/113-Validar%20token/servidor/?o=listadoaplicacionesusuario&usuario=ventas', '');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `seleccion_clientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `seleccion_clientes` (
`nombrecompleto` varchar(511)
,`email` varchar(255)
,`direccion` text
,`poblacion` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tablasaplicaciones`
--

CREATE TABLE `tablasaplicaciones` (
  `Identificador` int NOT NULL,
  `aplicaciones_nombre` int NOT NULL,
  `tabla` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tablasaplicaciones`
--

INSERT INTO `tablasaplicaciones` (`Identificador`, `aplicaciones_nombre`, `tabla`) VALUES
(1, 1, 'clientes'),
(2, 2, 'pedidos'),
(3, 3, 'productos'),
(4, 3, 'pedidos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `Identificador` int NOT NULL,
  `usuario` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contrasena` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `departamentos_nombre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`Identificador`, `usuario`, `contrasena`, `nombre`, `apellidos`, `departamentos_nombre`) VALUES
(1, 'jocarsa', 'jocarsa', 'Jose Vicente', 'Carratalá Sanchis', 1),
(3, 'ventas', 'ventas', 'Ventas', 'ventas', 1),
(4, 'facturacion', 'facturacion', 'facturacion', 'facturacion', 2);

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
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`Identificador`);

--
-- Indices de la tabla `departamentosaplicaciones`
--
ALTER TABLE `departamentosaplicaciones`
  ADD PRIMARY KEY (`Identificador`),
  ADD KEY `departamentosaplicaciones_departamentos` (`departamentos_nombre`),
  ADD KEY `departamentosaplicaciones_aplicaciones` (`aplicaciones_nombre`);

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
-- Indices de la tabla `registros`
--
ALTER TABLE `registros`
  ADD PRIMARY KEY (`Identificador`);

--
-- Indices de la tabla `tablasaplicaciones`
--
ALTER TABLE `tablasaplicaciones`
  ADD PRIMARY KEY (`Identificador`),
  ADD KEY `tablasaplicacionesatablas` (`aplicaciones_nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`Identificador`),
  ADD KEY `usuariosdepartamentos` (`departamentos_nombre`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aplicaciones`
--
ALTER TABLE `aplicaciones`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `departamentosaplicaciones`
--
ALTER TABLE `departamentosaplicaciones`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
-- AUTO_INCREMENT de la tabla `registros`
--
ALTER TABLE `registros`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=586;

--
-- AUTO_INCREMENT de la tabla `tablasaplicaciones`
--
ALTER TABLE `tablasaplicaciones`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `Identificador` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `departamentosaplicaciones`
--
ALTER TABLE `departamentosaplicaciones`
  ADD CONSTRAINT `departamentosaplicaciones_aplicaciones` FOREIGN KEY (`aplicaciones_nombre`) REFERENCES `aplicaciones` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `departamentosaplicaciones_departamentos` FOREIGN KEY (`departamentos_nombre`) REFERENCES `departamentos` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT;

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

--
-- Filtros para la tabla `tablasaplicaciones`
--
ALTER TABLE `tablasaplicaciones`
  ADD CONSTRAINT `tablasaplicacionesatablas` FOREIGN KEY (`aplicaciones_nombre`) REFERENCES `aplicaciones` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuariosdepartamentos` FOREIGN KEY (`departamentos_nombre`) REFERENCES `departamentos` (`Identificador`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
