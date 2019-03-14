/**
 * This is a sample file
 */
import {Component} from 'React'
import {add, subtract} from 'utils';

class Foo {
    field1 = 1;
    field2 = 2;

    foo() {
        console.log('foo')
    }

    static bar() {
        function hello(n) {
            console.log('hello ' + n)
        }

        var x = 1;


        while (x < 10) {
            hello(x)
        }
    }
}

interface IFoo {
    field: number
    field2: number

    foo(): void;
}
