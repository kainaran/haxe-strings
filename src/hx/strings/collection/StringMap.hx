/*
 * Copyright (c) 2016-2018 Vegard IT GmbH, https://vegardit.com
 * SPDX-License-Identifier: Apache-2.0
 */
package hx.strings.collection;

import hx.strings.internal.Macros;

/**
 * Abstract on <code>haxe.Constraints.IMap[String, V]</code>
 *
 * @author Sebastian Thomschke, Vegard IT GmbH
 */
@:forward
abstract StringMap<V>(haxe.Constraints.IMap<String, V>) from haxe.Constraints.IMap<String, V> to haxe.Constraints.IMap<String, V> {

    inline
    public function new() {
        this = new Map<String,V>();
    }

    @:to
    function __toMap():Map<String,V> {
        return cast this;
    }

    @:arrayAccess
    @:noCompletion
    @:noDoc @:dox(hide)
    inline
    public function __arrayGet(key:String):V {
        return this.get(key);
    }

    @:arrayAccess
    @:noCompletion
    @:noDoc @:dox(hide)
    inline
    public function __arrayWrite(k:String, v:V):V {
        this.set(k, v);
        return v;
    }

    /**
     * <b>IMPORTANT:</b> There is currently no native support for getting the size of a map,
     * therefore this is emulated for now by using an iterator - which impacts performance.
     *
     * <pre><code>
     * >>> new StringMap<Int>().size == 0
     * >>> ({var m = new StringMap<Int>(); m.set("1", 1); m.set("2", 1); m; }).size == 2
     * </code></pre>
     */
    public var size(get, never):Int;
    inline
    function get_size():Int {
        var count = 0;
        var it = this.keys();
        while (it.hasNext()) {
            it.next();
            count++;
        }
        return count;
    }

    /**
     * <pre><code>
     * >>> new StringMap<Int>().copy() != null
     * </code></pre>
     */
    public function copy():StringMap<V> {
        if (Std.is(this,
           #if java
           SortedStringMap.SortedStringMapImpl
           #else
           SortedStringMap
           #end
        )) {
            var m:SortedStringMap<V> = cast this;
            return m.copy();
        }

        if (Std.is(this,
           #if java
           OrderedStringMap.OrderedStringMapImpl
           #else
           OrderedStringMap
           #end
        )) {
            var m:OrderedStringMap<V> = cast this;
            return m.copy();
        }

        var clone:StringMap<V> = new StringMap<V>();
        for (k in this.keys()) {
            clone.set(k, this.get(k));
        }
        return clone;
    }

    /**
     * <pre><code>
     * >>> new StringMap<Int>().isEmpty() == true
     * >>> ({var m = new StringMap<Int>(); m.set("1", 1); m; }).isEmpty() == false
     * </code></pre>
     */
    inline
    public function isEmpty():Bool {
        return !this.iterator().hasNext();
    }

    /**
     * Copies all key-value pairs from the source map into this map.
     *
     * <pre><code>
     * >>> new StringMap<Int>().setAll(null) == 0
     * </code></pre>
     *
     * @param replace if true existing key-value pairs are replaced otherwise they will be skipped
     * @return the number of copied key-value pairs
     */
    public function setAll(items:StringMap<V>, replace:Bool = true):Int {
        if (items == null)
            return 0;

        var count = 0;
        if(replace) {
            for (k in items.keys()) {
                this.set(k, items.get(k));
                count++;
            }
        } else {
            for (k in items.keys()) {
                if(!this.exists(k)) {
                    this.set(k, items.get(k));
                    count++;
                }
            }
        }
        return count;
    }

}
