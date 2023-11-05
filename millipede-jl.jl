

str(v,s)  = join(map(i -> i ? "|"*s : "0"*s , v))

print_vec(v) = print(str(v,""),"\n")

key(n) = rand(Bool,n)

rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"

red() = rgb(255,0,0)
yellow() = rgb(255,255,0)
white() = rgb(255,255,255)
gray(h) = rgb(h,h,h)

function encode(p,q,x)
    f = deepcopy(q)
    n = size(q)[begin]
    c = Bool[]
    for i in eachindex(p)
        push!(c,Bool((f[x] + p[i])%2))
        f[x] = c[i]
        Bool(p[i]) ? x = mod1(x+2,n) : x = mod1(x+1,n)
    end
    c
end

function decode(c,q,x)
    f = deepcopy(q)
    n = size(q)[begin]
    p = Bool[]
    for i in eachindex(c)
        push!(p, Bool( (f[x] + c[i])%2 ) )
        f[x] = c[i]
        Bool(p[i]) ? x = mod1(x+2,n) : x = mod1(x+1,n)
    end
    p
end

function encrypt(p, q)
    f = deepcopy(q)
    n = size(f)[begin]
    for i in 1:n
        p = encode(p,f,i)
        p = reverse(p)
    end
    p
end


function decrypt(p, q)
    f = deepcopy(q)
    n = size(f)[begin]
    for i in 1:n
        p = reverse(p)
        p = decode(p,f,n + 1 - i)
    end
    p
end

function demo()
    f = key(32)
    print(white(),"f  ==  ", gray(255),str(f,""),"\n\n")
    for i in 1:8
        p = key(64)
        print(white(),"p  ==  ",red(), str(p,""),"\n")
        c = encrypt(p,f)
        print(white(),"c  ==  ",yellow(), str(c,""),"\n")
        print(white(),"       ", gray(100),str(p .!= c,""),"\n\n")
        d = decrypt(c,f)
        if p != d print("\nERROR\n") end
    end
    print(white())
end







