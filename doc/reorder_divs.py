#!/usr/bin/env python

# This file reads in "HTML" from a call to
#   thrift --gen html ....
# and does some post-processing to it.
# 1. It wraps struct headers + div definitions
#    in a div.
# 2. It reorders struct divs to be alphabetically
#    ordered.

from bs4 import BeautifulSoup
import fileinput
import logging

def make_nice_lines():
    looking_for_tag = False
    have_ending_tag = False
    char_buff = []
    logging.basicConfig()
    logger = logging.getLogger('make_nice_lines')
    logger.setLevel(logging.INFO)
    for line in fileinput.input():
        logger.debug("original line: " + line)
        for char in line:
            if char == '<' and len(char_buff) > 0:
                yield ''.join(char_buff)
                char_buff = []
            char_buff.append(char)
            if char == '<':
                looking_for_tag = True
            elif char == '/':
                if looking_for_tag:
                    have_ending_tag = True
            elif char == '>':
                looking_for_tag = False
                if have_ending_tag:
                    yield ''.join(char_buff)
                    char_buff = []
                    have_ending_tag = False
            else:
                pass
    yield ''.join(char_buff)


def add_divs():
    added_html = []
    main_pane = False
    in_h2 = False
    logging.basicConfig()
    logger = logging.getLogger('reorder_div')
    logger.setLevel(logging.INFO)
    for line in make_nice_lines():
        logger.debug("getting line::" + line)
        stripped_line = line.strip()
        if stripped_line.startswith('<div class="container-fluid"'):
            logger.debug("finding main pane")
            main_pane = True
            added_html.append(line)
            continue
        if not main_pane:
            added_html.append(line)
            continue
        # otherwise, we're in the main pane
        if stripped_line.startswith('<h2 id'):
            logger.debug("Found h2: " + stripped_line)
            in_h2 = True
            h2_id = stripped_line.split('"')[1]
            added_html.append('<div id="' + h2_id +'_div">')
            added_html.append(line)
            continue
        if in_h2:
            if stripped_line.startswith('<hr'):
                in_h2 = False
                added_html.append('</div>')
                added_html.append(line)
                continue
#            elif stripped_line.startsWith('<h2'):
            else:
                added_html.append(line)
        else:
            added_html.append(line)
    return added_html

def main():
    doc_with_divs = add_divs()
    bs_doc = BeautifulSoup(''.join(doc_with_divs), 'html.parser')
    structs = bs_doc.select('#Structs_div .definition')
    sorted_structs = sorted(structs, key = lambda x : x.select('h3')[0].get_text().strip())
    sd_dv = bs_doc.select('#Structs_div')
    if len(sd_dv) == 0:
        page = bs_doc.select('title')
        import sys
        print >> sys.stderr , "Generated page ", page[0].get_text(), " has no struct definitions. This is probably okay, but you may want to verify."
        print bs_doc.prettify()
        return 0
    div_children = sd_dv[0].contents
    if not(len(div_children) - 2 == len(sorted_structs)):
        raise Exception("length of div children (%s) != length of struct defs (%s)" % (len(div_children) - 2, len(sorted_structs)))
    for i in xrange(2, len(sorted_structs)+2):
        div_children[i] = sorted_structs[i-2]
    print bs_doc.prettify()
    return 0


if __name__ == '__main__':
    main()
