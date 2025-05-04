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
    TQUOTES = 258,                 /* TQUOTES  */
    TADD = 259,                    /* TADD  */
    TSUB = 260,                    /* TSUB  */
    TMUL = 261,                    /* TMUL  */
    TDIVENT = 262,                 /* TDIVENT  */
    TDIVREAL = 263,                /* TDIVREAL  */
    TASSIG = 264,                  /* TASSIG  */
    TID = 265,                     /* TID  */
    TFLOAT_CNST = 266,             /* TFLOAT_CNST  */
    TINT_CNST = 267,               /* TINT_CNST  */
    RFLOAT = 268,                  /* RFLOAT  */
    RINT = 269,                    /* RINT  */
    TCEQ = 270,                    /* TCEQ  */
    TCNE = 271,                    /* TCNE  */
    TCGE = 272,                    /* TCGE  */
    TCLE = 273,                    /* TCLE  */
    TCGT = 274,                    /* TCGT  */
    TCLT = 275,                    /* TCLT  */
    RPROGRAM = 276,                /* RPROGRAM  */
    RPROCEDURE = 277,              /* RPROCEDURE  */
    RMAIN = 278,                   /* RMAIN  */
    RDEF = 279,                    /* RDEF  */
    RLET = 280,                    /* RLET  */
    RIN = 281,                     /* RIN  */
    RID = 282,                     /* RID  */
    RFOREVER = 283,                /* RFOREVER  */
    RIF = 284,                     /* RIF  */
    RDO = 285,                     /* RDO  */
    RUNTIL = 286,                  /* RUNTIL  */
    RELSE = 287,                   /* RELSE  */
    RBREAK = 288,                  /* RBREAK  */
    RNEXT = 289,                   /* RNEXT  */
    RPRINT = 290,                  /* RPRINT  */
    RREAD = 291,                   /* RREAD  */
    TLPARENTHESIS = 292,           /* TLPARENTHESIS  */
    TRPARENTHESIS = 293,           /* TRPARENTHESIS  */
    TRBRACE = 294,                 /* TRBRACE  */
    TLBRACE = 295,                 /* TLBRACE  */
    TSEMIC = 296,                  /* TSEMIC  */
    THASHTAG = 297,                /* THASHTAG  */
    TDOLLAR = 298,                 /* TDOLLAR  */
    TUNDERSCORE = 299,             /* TUNDERSCORE  */
    TCOLON = 300,                  /* TCOLON  */
    TAPOSTROPHE = 301,             /* TAPOSTROPHE  */
    TCOMMA = 302,                  /* TCOMMA  */
    TAMPERSAND = 303,              /* TAMPERSAND  */
    TQMARK = 304,                  /* TQMARK  */
    TEMARK = 305,                  /* TEMARK  */
    TPERCENT = 306                 /* TPERCENT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 32 "parser.y"

    string *nombre              ;
    IdLista *list               ;
    expressionStruct *expr      ;
    statementStruct *stmt      ;
    int ref                  ;
    RefLista *lent              ;

#line 124 "parser.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_H_INCLUDED  */
