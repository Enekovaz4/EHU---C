/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    RPROGRAM = 258,                /* RPROGRAM  */
    RPROCEDURE = 259,              /* RPROCEDURE  */
    RMAIN = 260,                   /* RMAIN  */
    RDEF = 261,                    /* RDEF  */
    RLET = 262,                    /* RLET  */
    RIN = 263,                     /* RIN  */
    RID = 264,                     /* RID  */
    RINT = 265,                    /* RINT  */
    RFLOAT = 266,                  /* RFLOAT  */
    RFOREVER = 267,                /* RFOREVER  */
    RIF = 268,                     /* RIF  */
    RDO = 269,                     /* RDO  */
    RUNTIL = 270,                  /* RUNTIL  */
    RELSE = 271,                   /* RELSE  */
    RBREAK = 272,                  /* RBREAK  */
    RNEXT = 273,                   /* RNEXT  */
    RPRINT = 274,                  /* RPRINT  */
    RREAD = 275,                   /* RREAD  */
    TLPARENTHESIS = 276,           /* TLPARENTHESIS  */
    TRPARENTHESIS = 277,           /* TRPARENTHESIS  */
    TRBRACE = 278,                 /* TRBRACE  */
    TLBRACE = 279,                 /* TLBRACE  */
    TASSIG = 280,                  /* TASSIG  */
    TSEMIC = 281,                  /* TSEMIC  */
    THASHTAG = 282,                /* THASHTAG  */
    TDOLLAR = 283,                 /* TDOLLAR  */
    TUNDERSCORE = 284,             /* TUNDERSCORE  */
    TADD = 285,                    /* TADD  */
    TSUB = 286,                    /* TSUB  */
    TMUL = 287,                    /* TMUL  */
    TDIVENT = 288,                 /* TDIVENT  */
    TDIVREAL = 289,                /* TDIVREAL  */
    TCOLON = 290,                  /* TCOLON  */
    TAPOSTROPHE = 291,             /* TAPOSTROPHE  */
    TCOMMA = 292,                  /* TCOMMA  */
    TAMPERSAND = 293,              /* TAMPERSAND  */
    TCEQ = 294,                    /* TCEQ  */
    TCNE = 295,                    /* TCNE  */
    TCGE = 296,                    /* TCGE  */
    TCLE = 297,                    /* TCLE  */
    TCGT = 298,                    /* TCGT  */
    TCLT = 299,                    /* TCLT  */
    TQMARK = 300,                  /* TQMARK  */
    TEMARK = 301,                  /* TEMARK  */
    TPERCENT = 302,                /* TPERCENT  */
    TQUOTES = 303,                 /* TQUOTES  */
    TID = 304,                     /* TID  */
    TFLOAT_CNST = 305,             /* TFLOAT_CNST  */
    TINT_CNST = 306                /* TINT_CNST  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 22 "parser.y"

    string *name ; 

#line 119 "parser.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_H_INCLUDED  */
