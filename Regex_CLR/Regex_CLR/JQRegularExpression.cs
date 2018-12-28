using System;
using System.Data;
using System.Data.Sql;
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Collections;
// the IEnumerable interface is here 
// ---------------------------------------------------------------------------------------

// https://www.red-gate.com/simple-talk/sql/t-sql-programming/clr-assembly-regex-functions-for-sql-server-by-example/

namespace JQ.RegexCLR
{

    public class JQRegularExpression
    {

        // 
        //           RegExOptions function  
        // this is used simply to creat the bitmap that is passed to the various
        // CLR routines
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlInt32 RegExOptionEnumeration(SqlBoolean IgnoreCase, SqlBoolean MultiLine, 
            SqlBoolean ExplicitCapture, SqlBoolean Compiled, SqlBoolean SingleLine, SqlBoolean IgnorePatternWhitespace, 
            SqlBoolean RightToLeft, SqlBoolean ECMAScript, SqlBoolean CultureInvariant)
        {
            int Result = 0;


            if (IgnoreCase.Value == true) Result += (int)RegexOptions.IgnoreCase;
            if (MultiLine.Value == true) Result += (int)RegexOptions.Multiline;
            if (ExplicitCapture.Value == true) Result += (int)RegexOptions.ExplicitCapture;
            if (Compiled.Value == true) Result += (int)RegexOptions.Compiled;
            if (SingleLine.Value == true) Result += (int)RegexOptions.Singleline;
            if (IgnorePatternWhitespace.Value == true) Result += (int)RegexOptions.IgnorePatternWhitespace;
            if (RightToLeft.Value == true) Result += (int)RegexOptions.RightToLeft;
            if (ECMAScript.Value == true) Result += (int)RegexOptions.ECMAScript;
            if (CultureInvariant.Value == true) Result += (int)RegexOptions.CultureInvariant;
            
            return Result;
        }

        // ----------end of RegExEnumeration function
        // 
        //           RegExMatch function
        // This method returns the first substring found in input that matches the
        // regular expression pattern.
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlString RegExMatch(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return String.Empty;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = (int)Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return Regex.Match(input.Value, pattern.Value, RegexOption).Value;
        }

        // ----------end of RegExMatch function

        // ---------- RegExMatchGroups

        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlString RegExMatchGroups(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return String.Empty;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = (int)Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());


            string myOutput = "";

            int i = 0;
            foreach (Group group in Regex.Match(input.Value, pattern.Value, RegexOption).Groups)
            {



                if (!(i == 0))
                {
                    //Console.WriteLine(group.Value);
                    myOutput += group.Value + " ";

                }

                i++;

            }

            if (myOutput.Length > 0)
            {
                myOutput = myOutput.Substring(0, myOutput.Length - 1);
            }






            //return Regex.Match(input.Value, pattern.Value, RegexOption).Value;
            return myOutput;
        }

        // ---------- end RegExMatchGroups
                


        // end RegexOptions
        // RegExIsMatch function
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlBoolean RegExIsMatch(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return SqlBoolean.False;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return Regex.IsMatch(input.Value, pattern.Value, RegexOption);
        }

        // 
        //           RegExIndex function
        // This method returns the index of the first substring found in input that 
        // matches the regular expression pattern.
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlInt32 RegExIndex(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return 0;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return Regex.Match(input.Value, pattern.Value, RegexOption).Index;
        }

        // ----------end of RegExMatch function
        //           RegExEscape function
        // This method 'escapes'  a minimal set of characters (\, *, +, ?, |, {, [, (,),
        // ^,$,., #, and white space) by replacing them with their escape codes. This
        // instructs the regular expression engine to interpret these characters
        // literally rather than as metacharacters so you can pass any atring into
        // the pattern harmlessly.
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        public static SqlString RegExEscape(SqlString input)
        {
            if (input.IsNull)
            {
                return String.Empty;
            }

            return Regex.Escape(input.Value);
        }

        // ----------end of RegEscape function  
        //     
        //           RegExSplit function
        // RegexSplit function Splits an input string into an array of substrings at the
        // positions defined by a regular expression match.
        // This method splits the string at a delimiter determined by a regular
        // expression. The string is split as many times as possible. If no delimiter
        // is found, the return value contains one element whose value is the original
        // input parameter string.
        [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, IsPrecise = true, Name = "RegExSplit", SystemDataAccess = SystemDataAccessKind.None, FillRowMethodName = "NextSplitRow")]
        public static IEnumerable RegExSplit(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return null;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return Regex.Split(input.Value, pattern.Value, RegexOption);
        }

        private static void NextSplitRow(object input, ref SqlString match)
        {
            match = new SqlString(input.ToString());
        }

        // ----------end of RegexSplit function
        // 
        //           RegExReplace function
        // SQL Server version with parameters like TSQL: REPLACE
        // Within a specified input string, replaces all strings that match a specified
        // regular expression with a specified replacement string. Specified options
        // modify the matching operation.
        // this works like the SQL 'Replace' function on steroids.
        [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, IsPrecise = true, Name = "RegExReplace", SystemDataAccess = SystemDataAccessKind.None)]
        public static SqlString RegExReplace(SqlString input, SqlString pattern, SqlString replacement)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return SqlString.Null;
            }

            return new SqlString(Regex.Replace(input.Value, pattern.Value, replacement.Value, (RegexOptions.IgnoreCase | RegexOptions.Multiline)));
        }

        // ----------end of RegexReplace function
        // 
        //           RegExReplacex function
        // Logical version of the Regex Replace with parameters like the others
        // Within a specified input string, replaces all strings that match a specified
        // regular expression with a specified replacement string. Specified options
        // modify the matching operation.
        [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, IsPrecise = true, Name = "RegExReplacex", SystemDataAccess = SystemDataAccessKind.None)]
        public static SqlString RegExReplacex(SqlString pattern, SqlString input, SqlString replacement, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return SqlString.Null;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return new SqlString(Regex.Replace(input.Value, pattern.Value, replacement.Value, RegexOption));
        }

        // ----------end of RegexReplace function
        // 
        //          RegExMatches function
        // Searches the specified input string for all occurrences of the regular
        // expression supplied in a pattern parameter with matching options supplied
        // in an options parameter.
        [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, IsPrecise = true, Name = "RegExMatches", SystemDataAccess = SystemDataAccessKind.None, FillRowMethodName = "NextMatchedRow")]
        public static IEnumerable RegExMatches(SqlString pattern, SqlString input, SqlInt32 Options)
        {
            if ((input.IsNull || pattern.IsNull))
            {
                return null;
            }

            System.Text.RegularExpressions.RegexOptions RegexOption = new System.Text.RegularExpressions.RegexOptions();
            //RegexOption = Options;
            RegexOption = (RegexOptions)Enum.Parse(typeof(RegexOptions), Options.ToString());
            return Regex.Matches(input.Value, pattern.Value, RegexOption);
        }

        private static void NextMatchedRow(object input, ref SqlString match, ref SqlInt32 matchIndex, ref SqlInt32 matchLength)
        {
            Match match2 = (Match)input;
            match = new SqlString(match2.Value);
            matchIndex = new SqlInt32(match2.Index);
            matchLength = new SqlInt32(match2.Length);
        }
    }
}