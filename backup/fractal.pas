unit fractal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type vec = record
    x,y:real;
end;

type veci = record
    x,y:integer;
end;

type pch = ^chain;

chain = record
    v:vec;
    next:pch;
end;

type

{ mink }

 mink = class
  public
     head:pch;
     level:integer;
     constructor con;
     procedure init;
     procedure divide;
     procedure integrate;
     procedure tolevel(l:integer);
     procedure insafter(target:pch;x,y:real);
end;


implementation

{ mink }

constructor mink.con;
begin
   init;
end;

procedure mink.init;
begin
   level:=1;
   new(head);
   head^.next:=nil;
   head^.v.x:=1.0;
   head^.v.y:=0.0;
end;

procedure mink.insafter(target:pch;x,y:real);
var newn:pch;
begin
     new(newn);
     newn^.v.x:=x;
     newn^.v.y:=y;
     newn^.next:=target^.next;
     target^.next:=newn;
end;

procedure mink.divide;
var next, base, newn:pch;
  bx,by:real;
begin
     next:=head;
     while (next<>nil) do begin
           base:=next;
           next:=next^.next;
           base^.v.x:=base^.v.x/4;
           base^.v.y:=base^.v.y/4;
           bx:=base^.v.x;
           by:=base^.v.y;
           insafter(base, by,-bx);
           base:=base^.next;
           insafter(base, bx,by);
           base:=base^.next;
           insafter(base, -by,bx);
           base:=base^.next;
           insafter(base, -by,bx);
           base:=base^.next;
           insafter(base, bx,by);
           base:=base^.next;
           insafter(base, by,-bx);
           base:=base^.next;
           insafter(base, bx,by);
           base:=base^.next;
     end;
     level:=level+1;
end;



procedure mink.integrate;
var j:integer;
  del, next, rep:pch;
begin
     if(level>1) then begin
       next:=head;
       while (next<>nil) do begin
          next^.v.x:= next^.v.x*4;
          next^.v.y:= next^.v.y*4;
          rep:=next;
          next:=next^.next;
          for j:=1 to 7 do begin
              del:=next;
              next:=next^.next;
              dispose(del);
          end;
          rep^.next:=next;
       end;
     end;
     level:=level-1;
end;

procedure mink.tolevel(l: integer);
begin
     if(l>1) then begin
       while (l>level) do divide;
       while (l<level) do integrate;
     end;
end;

end.

