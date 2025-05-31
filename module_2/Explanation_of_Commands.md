## Explanation of Commands

### cut Command

The `cut` command is used to extract specific sections from each line of text:

* `-d":"`: Defines the delimiter as `:`.
* `-f3-6`: Specifies the fields to extract, in this case, from field 3 to field 6.

Example 1:

Extracting characters.
The command below shows how to extract the first four characters.

```sh
echo "database" | cut -c1-4
```
Output:

```
‘data’
```

Example 2:

```sh
echo "john:x:1001:1001:John Doe:/home/john:/bin/bash" | cut -d":" -f3-6
```

Output:

```
1001:1001:John Doe:/home/john
```

### tr Command

The `tr` command is used to translate or delete characters:

1️⃣ **Translate characters:**

```sh
echo "hello world" | tr "[a-z]" "[A-Z]"
```

Output:

```
HELLO WORLD
```

2️⃣ **Squeeze repeated characters:**

```sh
echo "aaabbbccc" | tr -s "a"
```

Output:

```
abbbccc
```

3️⃣ **Delete characters:**

```sh
echo "123-456-789" | tr -d "-"
```

Output:

```
123456789
```