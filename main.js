#!/usr/bin/env node

import {Parser, NamedNode, Store, Writer, Quad, DataFactory} from 'n3'
import {Readable} from 'node:stream'
import {parseArgs} from 'node:util'
import {URL} from 'node:url'
import {RdfaParser} from 'rdfa-streaming-parser'

const {positionals: [input]} = parseArgs({allowPositionals: true})

const myParser = new RdfaParser({baseIRI: input})

const source = await fetch(new URL(input))
const htmlStream = Readable.fromWeb(source.body)

const main = async () => new Promise((res, rej) => {
    const writer = new Writer()
    htmlStream.pipe(myParser)
        .on('data', quad => writer.addQuad(quad))
        .on('error', rej)
        .on('end', () => res(
            new Promise((res, rej) =>
                writer.end((err, result) => {
                    if (err) rej(err)
                    res(result)
                }))
        ))
})

console.log(await main())
