#!/bin/bash
echo "Content-Type: text/plain"
echo ""

echo "Hostname : $(hostname)"
echo "Apache Version :" && htpd -v
