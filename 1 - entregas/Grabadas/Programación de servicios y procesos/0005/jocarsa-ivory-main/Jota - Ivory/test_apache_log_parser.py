# test_apache_log_parser.py
"""
Tests unitarios para el módulo apache_log_parser.
"""

import unittest
from apache_log_parser import parse_log_line

class TestApacheLogParser(unittest.TestCase):
    def test_valid_log_line(self):
        line = '127.0.0.1 - - [10/Oct/2023:13:55:36 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0"'
        result = parse_log_line(line)
        self.assertIsNotNone(result)
        self.assertEqual(result['ip'], '127.0.0.1')
        self.assertEqual(result['status'], '200')
        self.assertEqual(result['user_agent'], 'Mozilla/5.0')
    
    def test_invalid_log_line(self):
        line = 'entrada de log inválida'
        result = parse_log_line(line)
        self.assertIsNone(result)

if __name__ == '__main__':
    unittest.main()
