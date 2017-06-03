#!/bin/bash

# Currently, grunt watch is broken, so we just re-run compile every 2s for development

while true
do
    grunt compile
    sleep 2
done