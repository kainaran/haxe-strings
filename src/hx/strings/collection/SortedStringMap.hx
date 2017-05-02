/*
 * Copyright (c) 2016-2017 Vegard IT GmbH, http://vegardit.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package hx.strings.collection;

import haxe.ds.BalancedTree;

import hx.strings.Strings;

/**
 * A map with sorted String keys.
 * 
 * @author Sebastian Thomschke, Vegard IT GmbH
 */
@:forward
abstract SortedStringMap<V>(SortedStringMapImpl<V>) from SortedStringMapImpl<V> {
    
    inline
    public function new(?comparator:String -> String -> Int) {
        this = new SortedStringMapImpl<V>(comparator);
    }
    
    @:to
    function __toStringMap():StringMap<V> {
        return cast this;
    }
    
    @:arrayAccess 
    @:noCompletion 
    @:noDoc @:dox(hide)
    public inline function __arrayGet(key:String) {
      return this.get(key);
    }

	@:arrayAccess 
    @:noCompletion 
    @:noDoc @:dox(hide)
    inline
    public function __arrayWrite(key:String, value:V):V {
		this.set(key, value);
		return value;
	}
}

private class SortedStringMapImpl<V> extends BalancedTree<String, V> implements haxe.Constraints.IMap<String,V> {

    var cmp:String -> String -> Int;

    /**
     * @param comparator used for sorting the String keys. Default is the UTF8 supporting Strings#compare() method
     */
    public function new(?comparator:String -> String -> Int) {
        super();
        this.cmp = comparator == null ? Strings.compare : comparator;
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
     * <pre><code>
     * >>> function(){var m = new SortedStringMap<Int>(); m.set("1", 1); m.clear(); return m.isEmpty(); }() == true
     * </code></pre>
     */
    inline
    public function clear():Void {
        root = null;
    }

    /**
     * <pre><code>
     * >>> new SortedStringMap<Int>().clone() != null
     * </code></pre>
     */
    inline
	public function clone():SortedStringMapImpl<V> {
        var clone = new SortedStringMapImpl<V>();
		for (k in this.keys()) {
			clone.set(k, this.get(k));
		}
		return clone;
	}

    inline
    override
    function compare(s1:String, s2:String):Int {
        return cmp(s1, s2);
    }

    /**
     * <pre><code>
     * >>> function(){var m = new SortedStringMap<Int>(); m.set("1", 10); return m["1"]; }() == 10
     * </code></pre>
     */
    @:arrayAccess
    override
	public function get(key:String):Null<V> {
		return super.get(key);
	}
    
    /**
     * <pre><code>
     * >>> new SortedStringMap<Int>().isEmpty() == true
     * >>> function(){var m = new SortedStringMap<Int>(); m.set("1", 1); return m.isEmpty(); }() == false
     * </code></pre>
     */
    inline
    public function isEmpty():Bool {
        return !this.iterator().hasNext();
    }
    
    /**
     * Copies all key-value pairs from the source map into this map.
     * 
     * @param replace if true existing key-value pairs are replaced otherwise they will be skipped
     * @return the number of copied key-value pairs
     */
    inline
    public function setAll(source:StringMap<V>, replace:Bool = true):Int {
        var m:StringMap<V> = this;
        return m.setAll(source, replace);
    }
}
